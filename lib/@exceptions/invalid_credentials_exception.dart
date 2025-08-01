class InvalidCredentialsException implements Exception {
  final String code;
  final String message;

  InvalidCredentialsException({required this.code, required this.message});

  @override
  String toString() {
    return 'Invalid credentials Exceptions: $code - $message';
  }
}
