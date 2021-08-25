import 'dart:convert';
import 'package:http/http.dart' as http;
import 'file_downloader.dart';
import 'package:igsaver/services/url_validator.dart';
import 'package:igsaver/exceptions/exceptions.dart';

class InstagramDownloader {
  final URLValidator urlValidator = URLValidator();
  final FileDownloader fileDownloader = FileDownloader();

  void downloadPost(String url) async {
    if (!urlValidator.isValid(url)) {
      return;
    }
    var data = await _fetchPostData(urlValidator.removeParams(url));
    _dispatch(data);
  }

  Future<dynamic> _fetchPostData(String url) async {
    http.Response response = await http.get(Uri.parse(url + '?__a=1'));

    if (response.statusCode == 404) {
      // 'Post not found. The post may be removed or the URL is broken'
      throw PostNotFoundException();
    }
    return jsonDecode(response.body)['graphql']['shortcode_media'];
  }

  void _dispatch(dynamic data) {
    switch (data['__typename']) {
      case 'GraphSidecar':
        _downloadAlbum(data);
        break;
      case 'GraphVideo':
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

  void _downloadAlbum(dynamic data) {
    List albumItems = data['edge_sidecar_to_children']['edges'];
    albumItems.forEach((element) {
      Map item = element['node'];

      // Add owner's username to the data manually, because it's not provided in `node` object by Instagram API
      //and it's necessary for naming files.
      item['owner'] = {};
      item['owner']['username'] = data['owner']['username'];

      _dispatch(item);
    });
  }

  void _downloadImage(dynamic data) {
    String imageURL = data['display_url'];
    String imageFilename =
        "${data['owner']['username']} ${data['shortcode']}.jpg";

    fileDownloader.download(imageURL, imageFilename);
  }

  void _downloadVideo(dynamic data) {
    String videoURL = data['video_url'];
    String videoFilename;

    if (data['title'] != null) {
      videoFilename = "${data['title']} ${data['shortcode']}.mp4";
    } else {
      videoFilename = "${data['owner']['username']} ${data['shortcode']}.mp4";
    }

    fileDownloader.download(videoURL, videoFilename, isVideo: true);
  }
}

class InstagramProfileDownloader extends InstagramDownloader {
  final String queryHash = '8c2a529969ee035a5063f2fc8602a0fd';
  final String profileAPI =
      'https://www.instagram.com/graphql/query/?query_hash=';

  Future<Map> getUserInfo(String username) async {
    http.Response response =
        await http.get(Uri.parse('https://www.instagram.com/$username/?__a=1'));

    if (response.statusCode == 404) {
      throw UserNotFoundException();
    }

    var userInfo = jsonDecode(response.body)['graphql']['user'];

    if (userInfo['is_private']) {
      throw PrivateAccountException();
    }

    if (userInfo['edge_owner_to_timeline_media']['count'] == 0) {
      throw AccountHaveNoPostException();
    }

    return {
      'id': userInfo['id'],
      'profilePicUrl': userInfo['profile_pic_url'],
      'username': userInfo['username'],
      'name': userInfo['full_name'],
      'postCount': userInfo['edge_owner_to_timeline_media']['count'],
    };
  }

  void downloadProfile(int userID, int numberOfPosts, bool imagesOnly) async {
    if (0 < numberOfPosts && numberOfPosts <= 50) {
      _downloadPartialProfile(userID, numberOfPosts, imagesOnly);
    } else {
      _downloadFullProfile(userID, imagesOnly);
    }
  }

  Future<void> _downloadPartialProfile(
      int userID, int numberOfPosts, bool imagesOnly) async {
    http.Response response = await http.get(Uri.parse(profileAPI +
        queryHash +
        '&variables={"id":"$userID","first":$numberOfPosts}'));

    var data = jsonDecode(response.body)['data']['user']
        ['edge_owner_to_timeline_media'];

    for (var post in data['edges']) {
      _dispatch(post['node']);
    }
  }

  Future<void> _downloadFullProfile(int userID, bool imagesOnly) async {
    bool hasNext = true;
    String endCursor = '';

    while (hasNext) {
      http.Response response = await http.get(Uri.parse(profileAPI +
          queryHash +
          '&variables={"id":"$userID","first":50,"after":"$endCursor"}'));

      var data = jsonDecode(response.body)['data']['user']
          ['edge_owner_to_timeline_media'];

      for (var post in data['edges']) {
        _dispatch(post['node']);
      }

      hasNext = data['page_info']['has_next_page'];
      endCursor = data['page_info']['end_cursor'];
    }
  }
}
