class ErrorHandler {
  final String? errorCode;
  final String? errorString;

  ErrorHandler({required this.errorCode, required this.errorString});

  factory ErrorHandler.empty() {
    return ErrorHandler(
      errorCode: null,
      errorString: null,
    );
  }
}
