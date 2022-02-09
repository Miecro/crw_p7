import 'dart:convert';
import 'dart:io';

import 'package:crw_p7/main.dart';
import 'package:crw_p7/shared.dart';
import 'package:crw_p7/write_sheet.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FlashCard extends StatefulWidget {
  final Text title;

  final Text desc;
  final Color containerColor;
  final Color btnColor;
  final String data;

  const FlashCard(
      {Key? key,
      required this.title,
      required this.desc,
      required this.containerColor,
      required this.btnColor, 
      required this.data})
      : super(key: key);
  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  Future<void> deleteFile() async {
    final _dir = await getApplicationDocumentsDirectory();
    final myFile = File(_dir.path + '/JDATA.json');
    String data = await myFile.readAsString(encoding: utf8);
    List testData = jsonDecode(data);
    String? t = widget.title.data;
    String? d = widget.desc.data;
    String td = '{Title: $t, Text: $d},';

    for (int a = 0; a < testData.length; a++) {
      if (testData[a]['Title'] == t) {
        testData.removeAt(a);
        
        break;
      }
    }
    var json = jsonEncode(testData);
    await myFile.writeAsString(json);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MainActivity();
    }));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.containerColor),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          widget.title,
                          SizedBox(width: width - 150),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Delete Note'),
                                  content: const Text(
                                      'This will delete note permanetly'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      
                                        child: Text('Delete'),
                                        
                                        onPressed: () {
                                          deleteFile();
                                          Navigator.pop(context, 'Cancel');
                                        }),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      widget.desc,
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                shared.title = widget.title.data.toString();
                shared.data = widget.data;

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return write_sheet();
                }));
              },
              child: (Text('OPEN')),
              style: TextButton.styleFrom(
                  backgroundColor: widget.btnColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
        ],
      ),
    );
  }
}
