class GeoRouterException implements Exception {
  final String message;

  GeoRouterException(this.message);

  @override
  String toString() => message;
}

class HttpException extends GeoRouterException {
  HttpException(int statusCode) : super('HTTP error: $statusCode');
}

class FormatException extends GeoRouterException {
  FormatException(String message) : super('Format error: $message');
}
