import 'dart:convert';

import 'package:app_gsheet_api/models/append_row_data.dart';
import 'package:http/http.dart' as http;

Future<AppendRowDataModel> appendRowData(
    {int? sheetNum, List<String>? data}) async {
  Uri url = Uri.http('localhost:8000', '/sheet/$sheetNum');
  String body = jsonEncode({"col_data": data});
  http.Response response = await http.post(url, body: body);
  AppendRowDataModel appendData = AppendRowDataModel();
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    appendData = AppendRowDataModel.fromJson(json);
  }
  return appendData;
}
