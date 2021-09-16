import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:igsaver/models/posts_list.dart';
import 'file_downloader.dart';
import 'package:igsaver/services/url_validator.dart';
import 'package:igsaver/exceptions/exceptions.dart';

class InstagramDownloader {
  final FileDownloader fileDownloader = FileDownloader();

  Future<http.Response> _get(String uri) async {
    http.Response response = await http.get(
      Uri.parse(uri),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0'
      },
    );

    return response;
  }

  void _dispatch(dynamic data, bool imagesOnly) {
    switch (data['__typename']) {
      case 'GraphSidecar':
        _downloadAlbum(data, imagesOnly);
        break;
      case 'GraphVideo':
        if (imagesOnly) {
          break;
        }
        _downloadVideo(data);
        break;
      case 'GraphImage':
        _downloadImage(data);
        break;
      default:
        // 'Unknown post type. Post should be image, video, album, reel or IGTv.'
        throw UnknownPostTypeException();
    }
  }

  void _downloadAlbum(dynamic data, bool imagesOnly) {
    List albumItems = data['edge_sidecar_to_children']['edges'];
    albumItems.forEach((element) {
      Map item = element['node'];

      // Add owner's username to the data manually, because it's not provided in `node` object by Instagram API
      //and it's necessary for naming files.
      item['owner'] = {};
      item['owner']['username'] = data['owner']['username'];

      _dispatch(item, imagesOnly);
    });
  }

  void _downloadImage(dynamic data) {
    String imageURL = data['display_url'];
    String imageFilename = "${data['owner']['username']}";

    if (data['shortcode'] == null) {
      imageFilename = "$imageFilename ${data['id']}.jpg";
    } else {
      imageFilename = "$imageFilename ${data['shortcode']}.jpg";
    }

    fileDownloader.download(imageURL, imageFilename);
  }

  void _downloadVideo(dynamic data) {
    String videoURL = data['video_url'];
    String videoFilename = "${data['owner']['username']}";

    if (data['title'] == null) {
      if (data['shortcode'] == null) {
        videoFilename = "$videoFilename ${data['id']}.mp4";
      } else {
        videoFilename = "$videoFilename ${data['shortcode']}.mp4";
      }
    } else {
      videoFilename = "$videoFilename ${data['title']}.mp4";
    }

    fileDownloader.download(videoURL, videoFilename, isVideo: true);
  }
}

class InstagramPostDownloader extends InstagramDownloader {
  final URLValidator urlValidator = URLValidator();

  Future<void> downloadPost(String url, bool imagesOnly) async {
    if (!urlValidator.isValid(url)) {
      throw InvalidUrlException();
    }

    String cleanedUrl = urlValidator.removeParams(url);
    http.Response response = await _get(cleanedUrl + '?__a=1');

    if (response.statusCode == 404) {
      throw PostNotFoundException();
    }

    var data = jsonDecode(response.body)['graphql']['shortcode_media'];

    _dispatch(data, imagesOnly);
  }
}

class InstagramProfileDownloader extends InstagramDownloader {
  final String queryHash = '8c2a529969ee035a5063f2fc8602a0fd';
  final String profileAPI =
      'https://www.instagram.com/graphql/query/?query_hash=';

  Future<Map> getUserInfo(String username) async {
    http.Response response =
        await _get('https://www.instagram.com/$username/?__a=1');

    if (response.statusCode == 404) {
      throw UserNotFoundException();
    }

    var userInfo = jsonDecode(response.body)['graphql']['user'];

    if (userInfo['is_private']) {
      throw PrivateAccountException();
    }

    if (userInfo['edge_owner_to_timeline_media']['count'] == 0) {
      throw AccountHasNoPostException();
    }

    return {
      'id': userInfo['id'],
      'name': userInfo['full_name'],
      'username': userInfo['username'],
      'is_verified': userInfo['is_verified'],
      'profilePicUrl': userInfo['profile_pic_url_hd'],
      'followers': userInfo['edge_followed_by']['count'],
      'postCount': userInfo['edge_owner_to_timeline_media']['count'],
    };
  }

  // Download posts selected by user
  Future<void> downloadSelectedPosts(PostsList posts) async {
    posts.list.forEach((key, value) {
      _dispatch(value, false);
    });
  }

  // Download all posts of a profile
  Future<void> downloadAllPosts(int userID, bool imagesOnly) async {
    bool hasNext = true;
    String endCursor = '';

    while (hasNext) {
      http.Response response = await _get(profileAPI +
          queryHash +
          '&variables={"id":"$userID","first":50,"after":"$endCursor"}');

      var data = jsonDecode(response.body)['data']['user']
          ['edge_owner_to_timeline_media'];

      for (var post in data['edges']) {
        _dispatch(post['node'], imagesOnly);
      }

      hasNext = data['page_info']['has_next_page'];
      endCursor = data['page_info']['end_cursor'];
    }
  }

  Stream<List> getProfilePosts(int userID) async* {
    bool hasNext = true;
    String endCursor = '';
    List posts = [];

    while (hasNext) {
      print('********fired********');
      http.Response response = await _get(profileAPI +
          queryHash +
          '&variables={"id":"$userID","first":50,"after":"$endCursor"}');

      var data = jsonDecode(response.body)['data']['user']
          ['edge_owner_to_timeline_media'];

      for (var post in data['edges']) {
        posts.add(post['node']);
      }

      yield posts;

      hasNext = data['page_info']['has_next_page'];
      endCursor = data['page_info']['end_cursor'];
    }
  }
}
