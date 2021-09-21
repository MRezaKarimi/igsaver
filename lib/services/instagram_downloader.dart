import 'dart:collection';
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

  Future<void> _dispatch(dynamic post, bool imagesOnly) async {
    switch (post['__typename']) {
      case 'GraphSidecar':
        _downloadAlbum(post, imagesOnly);
        break;
      case 'GraphVideo':
        if (imagesOnly) {
          break;
        }
        await _downloadVideo(post);
        break;
      case 'GraphImage':
        await _downloadImage(post);
        break;

      default:
        throw UnknownPostTypeException();
    }
  }

  void _downloadAlbum(dynamic post, bool imagesOnly) async {
    List album = post['edge_sidecar_to_children']['edges'];
    for (var element in album) {
      Map item = element['node'];

      /// Add owner's username to the data manually, because it's not provided in `node` object by Instagram API
      /// and it's necessary for naming files.
      item['owner'] = {};
      item['owner']['username'] = post['owner']['username'];

      await _dispatch(item, imagesOnly);
    }
  }

  Future<void> _downloadImage(dynamic data) async {
    String imageURL = data['display_url'];
    String imageFilename = "${data['owner']['username']}";

    if (data['shortcode'] == null) {
      imageFilename = "$imageFilename ${data['id']}.jpg";
    } else {
      imageFilename = "$imageFilename ${data['shortcode']}.jpg";
    }

    await fileDownloader.download(imageURL, imageFilename);
  }

  Future<void> _downloadVideo(dynamic data) async {
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

    await fileDownloader.download(videoURL, videoFilename, isVideo: true);
  }
}

class InstagramPostDownloader extends InstagramDownloader {
  final URLValidator urlValidator = URLValidator();

  Future<void> downloadPost(String url, bool imagesOnly) async {
    if (!urlValidator.isValid(url)) {
      throw InvalidUrlException();
    }

    String cleanedUrl = urlValidator.removeParams(url);

    if (cleanedUrl == '') {
      throw InvalidUrlException();
    }

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

  /// Download [posts] which are selected by user
  void downloadSelectedPosts(PostsList posts) async {
    var postsList = Map.of(posts.list);
    for (var post in postsList.values) {
      await _dispatch(post, false);
    }
  }

  /// Downloads all posts of the profile with given [userID]
  void downloadAllPosts(int userID, bool imagesOnly) async {
    bool hasNext = true;
    String endCursor = '';
    Queue downloadQueue = Queue();

    while (hasNext) {
      http.Response response = await _get(profileAPI +
          queryHash +
          '&variables={"id":"$userID","first":50,"after":"$endCursor"}');

      var data = jsonDecode(response.body)['data']['user']
          ['edge_owner_to_timeline_media'];

      for (var post in data['edges']) {
        downloadQueue.add(post['node']);
      }

      hasNext = data['page_info']['has_next_page'];
      endCursor = data['page_info']['end_cursor'];
    }

    while (downloadQueue.isNotEmpty) {
      await _dispatch(downloadQueue.removeFirst(), imagesOnly);
    }
  }

  Stream<List> getProfilePosts(int userID) async* {
    bool hasNext = true;
    String endCursor = '';
    List posts = [];

    while (hasNext) {
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
