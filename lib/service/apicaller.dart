import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mypaied/model/config.dart';
import 'package:dio/dio.dart';

class APICaller {
  final baseURL = Config().getHostName();
  final contentType = 'Content-Type';
  final String application = 'application/json; charset=UTF-8';

  // dynamic post(String url, Map<String, dynamic> obj) async {
  //   print(baseURL + url);
  //   await http
  //       .post(baseURL + url,
  //           headers: <String, String>{contentType: application},
  //           body: jsonEncode(obj))
  //       .then((value) {
  //     print(value.body);
  //   }).catchError((value) {
  //     print(value.message);
  //   });
  // }
}
