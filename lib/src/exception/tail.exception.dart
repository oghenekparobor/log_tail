class LogTailException implements Exception {
  LogTailException(
    this.statusCode, {
    this.request,
  });

  final int statusCode;
  final Map<String, dynamic>? request;

  String? get message {
    try {
      switch (statusCode) {
        case 403:
          return 'Unauthorized.';
        case 406:
          return "Couldn't parse JSON content.";
        case 413:
          return 'payload reached size limit.';
        default:
          return 'Something went wrong.';
      }
    } catch (e) {
      return null;
    }
  }
}
