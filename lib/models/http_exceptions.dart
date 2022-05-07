class HttpException implements Exception {
  String message;

  HttpException({required this.message});

  @override
  String toString() {
    print(message);
    return message;
  }
}
