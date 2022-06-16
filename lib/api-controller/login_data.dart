import 'dart:convert';

import 'package:app_gsheet_api/models/login_data.dart';
import 'package:http/http.dart' as http;

Future<LoginDataModel> loginData() async {
  Uri url = Uri.http('localhost:8000', '/login');
  http.Response response = await http.post(url);
  LoginDataModel loginData = LoginDataModel();
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    loginData = LoginDataModel.fromJson(json);
  }
  return loginData;
}
