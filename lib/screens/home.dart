import 'dart:convert';

import 'package:app_gsheet_api/api-controller/append_row_data.dart';
import 'package:app_gsheet_api/api-controller/get_row_data.dart';
import 'package:app_gsheet_api/api-controller/login_data.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  static const routeName = '/';
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController sheetNum = TextEditingController();
  TextEditingController rowNum = TextEditingController();
  List<String> dropDownValues = ['Get Row Data', 'Append Row Data', 'Login'];
  String dropDownCurrentValue = '';
  String data = "No Data";

  @override
  void initState() {
    super.initState();
    dropDownCurrentValue = dropDownValues.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: leftInput(),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async => executeApi(),
                      child: const Text('Execute'),
                    ),
                  ),
                  Expanded(
                    flex: 20,
                    child: Center(
                      child: Text(data),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future executeApi() async {
    const encoder = JsonEncoder.withIndent('  ');
    if (dropDownCurrentValue.compareTo(dropDownValues[0]) == 0) {
      await getRowData(
        sheetNum: int.parse(sheetNum.text),
        rowNum: int.parse(rowNum.text),
      ).then((val) => data = encoder.convert(val.toJson()));
    } else if (dropDownCurrentValue.compareTo(dropDownValues[1]) == 0) {
      await appendRowData(
              sheetNum: int.parse(sheetNum.text),
              data: [rowNum.text, 'data', 'tambahan'])
          .then((val) => data = encoder.convert(val.toJson()));
    } else if (dropDownCurrentValue.compareTo(dropDownValues[2]) == 0) {
      await loginData().then((value) => data = encoder.convert(value.toJson()));
    }
    setState(() {});
  }

  Column leftInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        DropdownButtonFormField(
            value: dropDownCurrentValue,
            items: dropDownValues.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropDownCurrentValue = newValue!;
              });
            }),
        TextFormField(
          controller: sheetNum,
          decoration: const InputDecoration(
            labelText: "Sheet",
          ),
        ),
        TextFormField(
          controller: rowNum,
          decoration: const InputDecoration(
            labelText: "Row",
          ),
        ),
      ],
    );
  }
}
