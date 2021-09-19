class URLValidator {
  RegExp _removeParamsRegEx = RegExp(
      r"https:\/\/www\.instagram\.com\/(p|tv|reel)\/([\w\-]+)\/",
      caseSensitive: false);

  RegExp _urlMatchRegEx = RegExp(
      r"https:\/\/www\.instagram\.com\/(p|tv|reel)\/([\w\-]+)\/.*",
      caseSensitive: false);

  // Check if the given url is a valid instagram url or not.
  bool isValid(String url) {
    return _urlMatchRegEx.hasMatch(url);
  }

  // Remove query params from url.
  String removeParams(String url) {
    return _removeParamsRegEx.stringMatch(url) ?? '';
  }
}
