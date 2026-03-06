class AppError implements Exception {
  const AppError({required this.message, this.debugMessage});

  final String message;
  final String? debugMessage;

  @override
  String toString() =>
      'AppError(message: $message, debugMessage: $debugMessage)';
}
