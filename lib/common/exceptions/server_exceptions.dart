class ApiException implements Exception {
  final String message;
  final Map<String, List<dynamic>> errors;

  const ApiException({this.message = '', this.errors = const {}});

  @override
  String toString() => 'ApiException: $message, errors: $errors';
}
