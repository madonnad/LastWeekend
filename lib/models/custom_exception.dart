class CustomException {
  final String? errorString;

  const CustomException({required this.errorString});

  static const empty = CustomException(
    errorString: null,
  );
}
