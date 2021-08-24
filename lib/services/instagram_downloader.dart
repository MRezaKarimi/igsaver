import 'dart:convert';
import 'file_downloader.dart';
import 'package:http/http.dart' as http;

class InstagramDownloader {
  final String queryHash = '8c2a529969ee035a5063f2fc8602a0fd';
  final String postApi = '';
  final FileDownloader fileDownloader = FileDownloader();

  void getPost(String url) async {
    if (url == '') {
      return;
    }

    var data = await _fetchData(url);
    _dispatch(data);
  }

  Future<dynamic> _fetchData(String url) async {
    http.Response response = await http.get(Uri.parse(url + '?__a=1'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['graphql']['shortcode_media'];
    } else if (response.statusCode == 404) {
      throw NotFoundException(
          'Post not found. The post may be removed or URL is broken.');
    }
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
        throw UnknownPostTypeException(
            'Unknown post type. Post should be image, video, album, reel or IGTv.');
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

    if (data['title'] != "") {
      videoFilename = "${data['title']} ${data['shortcode']}.mp4";
    } else {
      videoFilename = "${data['owner']['username']} ${data['shortcode']}.mp4";
    }

    fileDownloader.download(videoURL, videoFilename, isVideo: true);
  }
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);

  @override
  String toString() => message;
}

class UnknownPostTypeException implements Exception {
  final String message;

  UnknownPostTypeException(this.message);

  @override
  String toString() => message;
}
