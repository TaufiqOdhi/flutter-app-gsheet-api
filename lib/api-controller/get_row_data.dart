import 'dart:convert';

import 'package:app_gsheet_api/models/get_row_data.dart';
import 'package:http/http.dart' as http;

Future<GetRowDataModel> getRowData({int? sheetNum, int? rowNum}) async {
  Uri url = Uri.http('localhost:8000', '/sheet/$sheetNum/$rowNum');
  http.Response response = await http.get(url);
  GetRowDataModel rowData = GetRowDataModel();
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    rowData = GetRowDataModel.fromJson(json);
  }
  return rowData;
}
