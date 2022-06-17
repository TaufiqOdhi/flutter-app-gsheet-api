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
  String dropDownCurrVal = '';
  String data = "No Data";
  List<Widget> listAppend = [];
  List<TextEditingController> listAppendController = [];

  @override
  void initState() {
    super.initState();
    dropDownCurrVal = dropDownValues.first;
    addRowDataForm();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: listInput(),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("jSON"),
                            ),
                            const SizedBox(),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Table"),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async => executeApi(),
                          child: const Text('Execute'),
                        ),
                      ],
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
    if (dropDownCurrVal.compareTo(dropDownValues[0]) == 0) {
      await getRowData(
        sheetNum: int.parse(sheetNum.text),
        rowNum: int.parse(rowNum.text),
      ).then((val) => data = encoder.convert(val.toJson()));
    } else if (dropDownCurrVal.compareTo(dropDownValues[1]) == 0) {
      await appendRowData(
              sheetNum: int.parse(sheetNum.text), data: listAppendController)
          .then((val) => data = encoder.convert(val.toJson()));
    } else if (dropDownCurrVal.compareTo(dropDownValues[2]) == 0) {
      await loginData().then((value) => data = encoder.convert(value.toJson()));
    }
    setState(() {});
  }

  addRowDataForm() {
    listAppendController.add(TextEditingController());
    listAppend.add(TextFormField(
      controller: listAppendController.last,
      decoration: InputDecoration(
        labelText: "Row Data Column ${listAppendController.length}",
      ),
    ));
  }

  resetRowDataForm() {
    listAppendController.clear();
    listAppend.clear();
    addRowDataForm();
  }

  List<Widget> listInput() {
    List<Widget> inputs = [
      DropdownButtonFormField(
          value: dropDownCurrVal,
          items: dropDownValues.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropDownCurrVal = newValue!;
              resetRowDataForm();
            });
          }),
    ];
    if (dropDownCurrVal.compareTo(dropDownValues[2]) != 0) {
      inputs.add(
        TextFormField(
          controller: sheetNum,
          decoration: const InputDecoration(
            labelText: "Sheet",
          ),
        ),
      );
    }

    if (dropDownCurrVal.compareTo(dropDownValues[0]) == 0) {
      inputs.add(
        TextFormField(
          controller: rowNum,
          decoration: const InputDecoration(
            labelText: "Row",
          ),
        ),
      );
    } else if (dropDownCurrVal.compareTo(dropDownValues[1]) == 0) {
      for (Widget element in listAppend) {
        inputs.add(element);
      }
      inputs.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ElevatedButton(
            onPressed: () {
              setState(() {
                addRowDataForm();
              });
            },
            child: const Text("Add More Row Data")),
      ));
    }
    return inputs;
  }
}
