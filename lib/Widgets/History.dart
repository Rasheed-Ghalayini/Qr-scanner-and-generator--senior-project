// ignore_for_file: file_names

import 'package:senior_barcode/Widgets/HistoryItem.dart';
import 'package:senior_barcode/Widgets/SearchAppBar.dart';
import 'package:senior_barcode/data/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool _searchBoolean = false;
  final _myBox = Hive.box('mybox');
  ScansDatabase db = ScansDatabase();
  List<dynamic> scans = [];

  @override
  void initState() {
    // TODO: implement initState

    if (_myBox.get('SCANS') == null) {
      db.createInitialData();
      // print(_myBox.get('SCANS'));
    } else {
      //db.createInitialData();

      db.loadData();
      setState(() {
        scans = db.scans!;
      });
    }

    super.initState();
  }

  // Widget _searchTextField() {
  //   return TextField(
  //       onChanged: (String s) { //add
  //         setState(() {
  //           _searchIndexList = [];
  //           for (int i = 0; i < db.scans!.length; i++) {
  //             if (db.scans![i].content.contains(s)) {
  //               _searchIndexList.add(i);
  //             }
  //           }
  //         });
  //       },
  //   );
  // }
  //
  Widget _searchListView() {
    //add
    return ListView.builder(
        itemCount: scans!.length,
        itemBuilder: (context, index) {
          final item = scans?[index];
          return HistoryItem(scan: item);
        });
  }

  Widget _defaultListView() {
    return ListView.builder(
        itemCount: db.scans?.length,
        itemBuilder: (context, index) {
          final item = db.scans?[index];
          return HistoryItem(scan: item);
        });
  }

  Widget _searchTextField() {
    return TextField(
      autofocus: true,
      //Display the keyboard when TextField is displayed
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      //Specify the action button on the keyboard
      decoration: InputDecoration(
        //Style of TextField
        enabledBorder: UnderlineInputBorder(
            //Default TextField border
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: UnderlineInputBorder(
            //Borders when a TextField is in focus
            borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search', //Text that is displayed when nothing is entered.
        hintStyle: TextStyle(
          //Style of hintText
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
      onChanged: (String s) {
        //add
        setState(() {
          scans = [];
          for (int i = 0; i < db.scans!.length; i++) {
            if (db.scans![i].content.contains(s)) {
              scans.add(db.scans![i]);
            }
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_searchBoolean ? Text("History") : _searchTextField(),
        actions:!_searchBoolean
            ? [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _searchBoolean = true;
                });
              }),
          IconButton(
              onPressed: () => {
                setState(() {
                  db.clearHistory();
                  // db.updateDatabase();
                  if (kDebugMode) {
                    print(scans);
                  }
                })
              },
              icon: const Icon(Icons.cleaning_services))
        ]
            : [
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchBoolean = false;
                });
              }
          ),
          IconButton(
              onPressed: () => {
                setState(() {
                  db.clearHistory();
                  // db.updateDatabase();
                  if (kDebugMode) {
                    print(scans);
                  }
                })
              },
              icon: const Icon(Icons.cleaning_services))
        ]
      ),
      body: !_searchBoolean ? _defaultListView() : _searchListView(),
    );
  }
}
