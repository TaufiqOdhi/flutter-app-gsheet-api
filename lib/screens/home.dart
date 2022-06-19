import 'dart:convert';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:app_gsheet_api/api-controller/append_row_data.dart';
import 'package:app_gsheet_api/api-controller/get_row_data.dart';
import 'package:app_gsheet_api/api-controller/login_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int greyLevel = 300;
  int flexForm = 3;
  int flexLabel = 2;
  bool isLoading = false;

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
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: listInput(),
                ),
              ),
            ),
            Expanded(
              flex: 5,
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
                      child: isLoading
                          ? LoadingAnimationWidget.discreteCircle(
                              color: Theme.of(context).primaryColor,
                              size: 50,
                            )
                          : Text(data),
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
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      isLoading = false;
    });
  }

  addRowDataForm() {
    listAppendController.add(TextEditingController());
    listAppend.add(Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 15),
      child: Row(
        children: [
          Expanded(
            flex: flexLabel,
            child: Text("Row Data Col ${listAppendController.length}"),
          ),
          Expanded(
            flex: flexForm,
            child: TextFormField(
              controller: listAppendController.last,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[greyLevel],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
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
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: DropdownButtonFormField(
            value: dropDownCurrVal,
            decoration: InputDecoration(
              fillColor: Colors.grey[greyLevel],
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            items: dropDownValues.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropDownCurrVal = newValue!;
                sheetNum.text = ''; //untuk clear form
                rowNum.text = ''; //untuk clear form
                resetRowDataForm();
              });
            }),
      ),
    ];
    if (dropDownCurrVal.compareTo(dropDownValues[2]) != 0) {
      inputs.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 15),
          child: Row(
            children: [
              Expanded(
                flex: flexLabel,
                child: const Text('Sheet'),
              ),
              Expanded(
                flex: flexForm,
                child: TextFormField(
                  controller: sheetNum,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[greyLevel],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (dropDownCurrVal.compareTo(dropDownValues[0]) == 0) {
      inputs.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 15),
          child: Row(
            children: [
              Expanded(
                  flex: flexLabel,
                  child: const Text(
                    "Row",
                  )),
              Expanded(
                flex: flexForm,
                child: TextFormField(
                  controller: rowNum,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[greyLevel],
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
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
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              addRowDataForm();
            });
          },
          child: const Text("Add More Row Data"),
        ),
      ));
    }
    return inputs;
  }
}
