import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dringo/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dringo.dart';

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

BaseOptions options = new BaseOptions(
    baseUrl: Constants.API_URL, connectTimeout: 5000, receiveTimeout: 3000);
Dio dio = new Dio(options);

void main() {
  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  runApp(Dringo());
}
