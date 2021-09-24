/// Validates and cleans instagram urls
class URLValidator {
  RegExp _removeParamsRegEx = RegExp(
      r"https:\/\/www\.instagram\.com\/(p|tv|reel)\/([\w\-]+)\/",
      caseSensitive: false);

  RegExp _urlMatchRegEx = RegExp(
      r"https:\/\/www\.instagram\.com\/(p|tv|reel)\/([\w\-]+)\/.*",
      caseSensitive: false);

  /// Checks if the [url] is a valid instagram post url.
  bool isValid(String url) {
    return _urlMatchRegEx.hasMatch(url);
  }

  /// Removes query params from [url] and returns a cleaned instagram post url.
  String removeParams(String url) {
    return _removeParamsRegEx.stringMatch(url) ?? '';
  }
}
