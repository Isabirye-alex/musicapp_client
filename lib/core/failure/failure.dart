class AppFailure {
  final String message;

  const AppFailure({this.message = 'Sorry unexpected error occurred'});

  @override
  String toString() => '''message: sign in error''';
}
