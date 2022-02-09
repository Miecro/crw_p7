// main.dart
import 'dart:convert';
import 'dart:io';

import 'package:crw_p7/FlashCard.dart';
import 'package:crw_p7/shared.dart';
import 'package:crw_p7/write_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MainActivity());
}

class MainActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List testData = List.empty();
  List<Widget> extractedChildren = <Widget>[];
  String content = '';
  final textController = TextEditingController();

  Future<String> getDirPath() async {
    final _dir = await getApplicationDocumentsDirectory();
    return _dir.path;
  }

  Future<void> readJson() async {
    var myFile;
     String t='';
    final _dir = await getApplicationDocumentsDirectory();

    try {
      myFile = File(_dir.path + '/JDATA.json');
      String data = await myFile.readAsString(encoding: utf8);
      data = await myFile.readAsString(encoding: utf8);
      setState(() {
        testData = jsonDecode(data);
      });
      
    } catch (e) {
      myFile = File(_dir.path + '/JDATA.json');
      myFile.create();
      await myFile.writeAsString('[]');
      
    }
    for (int a = 0; a < testData.length; a++) {
      
      
        if(testData[a]!=null)
        {
         t = testData[a]['Text'].toString();
          t=t.replaceAll('\n', ',');
          if(t.length>50)
          {
            t=t.substring(0,40);
             t+=' ...';
          }
          
         
          extractedChildren.add(FlashCard(
          title: Text(testData[a]['Title'].toString()),
          desc: Text(t),
          containerColor: Colors.white,
          btnColor: Colors.blue, data: testData[a]['Text'].toString(),));
        }
      }
     
      
  }

  void initState() {
    readJson();
  }

  //?--------------------------------------------------------------------------------------------------------------------------
  //! -------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Option Menu
    void handleClick(String choice) {
      if (choice == 'New') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return write_sheet();
        }));
      }
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 26, 25, 25),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 123, 0),
          title: Text('Noter'),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'New'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(children: extractedChildren),
              ),
            ],
          ),
        ));
  }

  //!---------------------------------------------------------------------------------------------------------------------------
}
