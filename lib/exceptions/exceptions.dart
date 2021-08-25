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

class PrivateAccountException implements Exception {}

class AccountHaveNoPostException implements Exception {}
