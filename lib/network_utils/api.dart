import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingletonDio {
  static var cookiemanager = CookieManager(CookieJar());

  static Dio getDio() {
    Dio dio = Dio();
    dio.interceptors.add(cookiemanager);
    return dio;
  }
}

class Network {
  final String _url = 'http://10.0.2.2:8000/api';
  //when using android studio emulator, change localhost to 10.0.2.2

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    var response =
        await SingletonDio.getDio().post(fullUrl, data: jsonEncode(data));
    // print(response);
    return response; // return json.decode(response.body)
  }

  getPublicData(apiUrl) async {
    var response =
        await SingletonDio.getDio().get(_url + apiUrl + await _getToken());
    return response;
  }

  Map<String, String> _setHeaders = {
    'Content-Type': 'application/json',
    'Charset': 'utf-8',
    'Accept': 'application/json',
    // 'Cookie': 'cookie'
  };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }
}
