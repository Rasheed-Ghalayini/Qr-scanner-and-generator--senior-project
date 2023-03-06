// ignore_for_file: file_names

import 'package:senior_barcode/data/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'HistoryGeneratedItem.dart';




class HistoryGenerated extends StatefulWidget {
  const HistoryGenerated({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HistoryGeneratedState createState() => _HistoryGeneratedState();
}

class _HistoryGeneratedState extends State<HistoryGenerated> {
  final _myBox = Hive.box('mybox');
  bool _searchBoolean = false;
  BarcodesDatabase db = BarcodesDatabase();
  List<dynamic> gens = [];

  @override
  void initState() {

    // TODO: implement initState
    if(_myBox.get('BARCODES') == null){
      db.createInitialData();
      // print(_myBox.get('SCANS'));
    }else{
       //db.createInitialData();
      db.loadData();
    }
    setState(() {
      gens = db.genBarcodes!;
    });
    super.initState();
  }
  Widget _searchListView() {
    //add
    return ListView.builder(itemCount:gens?.length,itemBuilder: (context, index) {
      final item = gens?[index];
      return HistoryGeneratedItem(barcode: item,index:index);
    });
  }

  Widget _defaultListView() {
    return ListView.builder(itemCount:db.genBarcodes?.length,itemBuilder: (context, index) {
          final item = db.genBarcodes?[index];
          return HistoryGeneratedItem(barcode: item,index:index);
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
          gens = [];
          for (int i = 0; i < db.genBarcodes!.length; i++) {
            if (db.genBarcodes![i].content.contains(s)) {
              gens.add(db.genBarcodes![i]);
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
                      print(gens);
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
                      print(gens);
                    }
                  })
                },
                icon: const Icon(Icons.cleaning_services))
          ]
      ),
      body: !_searchBoolean ? _defaultListView() : _searchListView(),
    );


    // return Scaffold(
    //   appBar: AppBar(title: const Text("Generated Barcodes"),actions: [IconButton(onPressed: () =>{setState((){
    //     db.clearHistory();
    //     // db.updateDatabase();
    //     if (kDebugMode) {
    //       print(db.genBarcodes);
    //     }
    //   })}, icon: const Icon(Icons.cleaning_services))],),
    //   body: ListView.builder(itemCount:db.genBarcodes?.length,itemBuilder: (context, index) {
    //     final item = db.genBarcodes?[index];
    //     return HistoryGeneratedItem(barcode: item,index:index);
    //   }),
    // );
  }
}
