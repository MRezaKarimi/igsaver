class URLValidator {
  RegExp _removeParamsRegEx = RegExp(
      '(https:\/\/www\.instagram\.com\/p\/([^\/?#&]+))\/',
      caseSensitive: false);

  RegExp _urlMatchRegEx = RegExp(
      '(https:\/\/www\.instagram\.com\/p\/([^\/?#&]+)).*',
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
