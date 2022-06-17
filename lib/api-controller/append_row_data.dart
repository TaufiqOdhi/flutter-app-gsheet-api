import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_gsheet_api/models/append_row_data.dart';
import 'package:http/http.dart' as http;

Future<AppendRowDataModel> appendRowData(
    {int? sheetNum, List<TextEditingController>? data}) async {
  List<String> colData = [];
  data?.forEach((element) {
    colData.add(element.text);
  });

  Uri url = Uri.http('localhost:8000', '/sheet/$sheetNum');
  String body = jsonEncode({"col_data": colData});
  http.Response response = await http.post(url, body: body);
  AppendRowDataModel appendData = AppendRowDataModel();
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    appendData = AppendRowDataModel.fromJson(json);
  }
  return appendData;
}
