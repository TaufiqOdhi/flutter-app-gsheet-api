import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
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
  ScrollController verticalScroll = ScrollController();
  ScrollController horizontalScroll = ScrollController();
  List<String> dropDownValues = ['Get Row Data', 'Append Row Data', 'Login'];
  String dropDownCurrVal = '';
  List<Map<String, dynamic>> data = [
    {"data": "No Data"}
  ];
  List<Widget> listAppend = [];
  List<TextEditingController> listAppendController = [];
  int greyLevel = 300;
  int flexForm = 3;
  int flexLabel = 2;
  bool isLoading = false;
  List<String> listResultMenu = ['jSON', 'Table'];
  String resultMenu = '';

  @override
  void initState() {
    super.initState();
    dropDownCurrVal = dropDownValues.first;
    addRowDataForm();
    resultMenu = listResultMenu[1];
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
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: listInput(),
                  ),
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
                              onPressed: () {
                                setState(() {
                                  resultMenu = listResultMenu[0];
                                });
                              },
                              child: Text(listResultMenu[0]),
                            ),
                            const SizedBox(),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  resultMenu = listResultMenu[1];
                                });
                              },
                              child: Text(listResultMenu[1]),
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
                    child: isLoading
                        ? Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              color: Theme.of(context).primaryColor,
                              size: 50,
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 9.0, 8.0, 20.0),
                            child: resultWidget(),
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

  Widget resultWidget() {
    const encoder = JsonEncoder.withIndent('  ');
    if (data[0]['data'].toString().compareTo('No Data') == 0) {
      return Center(child: Text(data[0]['data']));
    } else if (resultMenu.compareTo(listResultMenu[0]) == 0) {
      return Center(
        child: Text(encoder.convert(data[0])),
      );
    } else {
      return AdaptiveScrollbar(
        sliderActiveColor: Theme.of(context).primaryColor,
        sliderDefaultColor: Theme.of(context).primaryColorDark,
        controller: verticalScroll,
        child: AdaptiveScrollbar(
          sliderActiveColor: Theme.of(context).primaryColor,
          sliderDefaultColor: Theme.of(context).primaryColorDark,
          controller: horizontalScroll,
          position: ScrollbarPosition.bottom,
          child: SingleChildScrollView(
            controller: verticalScroll,
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              controller: horizontalScroll,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataRowHeight: 300,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).primaryColorDark,
                ),
                headingTextStyle: const TextStyle(
                  color: Colors.white,
                ),
                columns: data[0].keys.map<DataColumn>((e) {
                  return DataColumn(label: Center(child: Text(e)));
                }).toList(),
                rows: data.map<DataRow>((e) {
                  List<DataCell> dataCell = [];
                  e.forEach((key, value) {
                    dataCell.add(DataCell(
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(encoder.convert(value)),
                      ),
                    ));
                  });
                  return DataRow(cells: dataCell);
                }).toList(),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future executeApi() async {
    setState(() {
      isLoading = true;
    });
    if (dropDownCurrVal.compareTo(dropDownValues[0]) == 0) {
      await getRowData(
        sheetNum: int.parse(sheetNum.text),
        rowNum: int.parse(rowNum.text),
      ).then((val) => data = [val.toJson()]);
    } else if (dropDownCurrVal.compareTo(dropDownValues[1]) == 0) {
      await appendRowData(
              sheetNum: int.parse(sheetNum.text), data: listAppendController)
          .then((val) => data = [val.toJson()]);
    } else if (dropDownCurrVal.compareTo(dropDownValues[2]) == 0) {
      await loginData().then((val) => data = [val.toJson()]);
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
              textAlign: TextAlign.center,
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
                  textAlign: TextAlign.center,
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
                  textAlign: TextAlign.center,
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
