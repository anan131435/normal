import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

Client get nosslClient {
  // 自定义证书验证
  var ioClient = HttpClient()..badCertificateCallback = (_, __, ___) => true;
  // 自定义代理
  // ioClient.findProxy = (_) => "";
  return IOClient(ioClient);
}

Future<Response> get(String url, {Map<String, String>? headers}) {
  return nosslClient.get(Uri.parse(url), headers: headers);
}

Future<Response> put(String url, {Map<String, String>? headers, dynamic body}) {
  return nosslClient.put(Uri.parse(url), headers: headers, body: body);
}

Future<Response> post(String url,
    {Map<String, String>? headers, dynamic body, Encoding? encoding}) async {
  final response = await nosslClient.post(Uri.parse(url),
      headers: headers, body: body, encoding: encoding);

  if (response.statusCode == 302 || response.statusCode == 301) {
    var location = response.headers['location'];

    return nosslClient.get(Uri.parse(url).resolve(location!),
        headers: headers);
  }
  return response;
}
