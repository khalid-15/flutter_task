import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  final String _url = 'http://10.0.2.2:8000/api';

  getPublicData(apiUrl) async {
    http.Response response = await http.get(
        Uri.parse(_url + apiUrl + await _getToken()),
        headers: _setHeaders);
    try {
      if (response.statusCode == 200) {
        return response;
      } else {
        return 'failed';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
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
