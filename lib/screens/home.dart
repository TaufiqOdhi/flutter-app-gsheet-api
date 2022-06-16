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
  String dropDownValue = 'One';

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
            const Expanded(
              flex: 3,
              child: Center(
                child: Text("No Data"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column leftInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        DropdownButtonFormField(
            value: dropDownValue,
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropDownValue = newValue!;
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
