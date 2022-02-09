import 'dart:math';

import 'package:crw_p7/main.dart';
import 'package:crw_p7/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class write_sheet extends StatefulWidget {
  const write_sheet({Key? key}) : super(key: key);

  @override
  _write_sheetState createState() => _write_sheetState();
}

class _write_sheetState extends State<write_sheet> {
  //!--------------------------------------------------------------------------------
  String DataList = '';

  final textController = TextEditingController();
  final appBarText = TextEditingController();
  Future<void> read() async {
    final _dir = await getApplicationDocumentsDirectory();
    final myFile = File(_dir.path + '/JDATA.json');
    String data = await myFile.readAsString(encoding: utf8);

    List testData = jsonDecode(data);
  }

  Future<void> writeData() async {
    final _dir = await getApplicationDocumentsDirectory();
    final myFile = File(_dir.path + '/JDATA.json');
    String s2 = textController.text;
    String s1 = appBarText.text;
    bool checkIfExist = false;

    String data = await myFile.readAsString(encoding: utf8);

    List testData = jsonDecode(data);

    for (var a in testData) {
      if (a['Title'] == appBarText.text) {
        checkIfExist = true;
      }
    }

    if (checkIfExist == false) {
      testData.add({"Title": "$s1", "Text": "$s2"});

      var json = jsonEncode(testData);
      await myFile.writeAsString(json);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MainActivity();
      }));
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Warning ...'),
          content: const Text('Do you want to replace the note ? '),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                }),
            TextButton(
                child: const Text('Replace'),
                onPressed: () async {
                  for (int a = 0; a < testData.length; a++) {
                    if (testData[a]['Title'] == s1) {
                      testData[a]['Text'] = s2;
                    }
                  }
                  var json = jsonEncode(testData);

                  await myFile.writeAsString(json);

                  Navigator.pop(context, 'Replace');
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MainActivity();
                  }));
                }),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBarText.text = shared.title;
    textController.text = shared.data;
  }

  //!--------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 26, 25, 25),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              shared.title = '';
              shared.data = '';
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MainActivity();
              }));
            },
          ),
          backgroundColor: Color.fromARGB(255, 255, 123, 0),
          centerTitle: true,
          title: Text(appBarText.text),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                        alignment: Alignment.topRight,
                        child: TextButton(
                          child: Text('DONE'),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: TextField(
                                    controller: appBarText,
                                    decoration: InputDecoration(
                                        labelText: 'Enter Title')),
                                actions: <Widget>[
                                  TextButton(
                                      child: Text('Save'),
                                      onPressed: () {
                                        writeData();
                                        shared.title = '';
                                        shared.data = '';
                                        Navigator.pop(context, 'Save');
                                      }),
                                ],
                              ),
                            );
                          },
                        )),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color.fromARGB(255, 26, 25, 25),
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: textController,

                        //textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 26, 25, 25),
                                width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 26, 25, 25),
                                width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 26, 25, 25),
                                width: 2.0),
                          ),
                          hintText: ('Text'),
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 123, 0),
                          ),
                          contentPadding: EdgeInsets.all(25.0),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
