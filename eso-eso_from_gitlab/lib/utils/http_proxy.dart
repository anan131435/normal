import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    var http = super.createHttpClient(context);
    http.findProxy = (uri) {
      return 'PROXY 172.16.32.237:8888';
    };
    http.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return http;
  }
}