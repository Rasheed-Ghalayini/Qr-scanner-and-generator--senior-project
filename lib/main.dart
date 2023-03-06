import 'package:senior_barcode/Screens/MainScreen.dart';
import 'package:senior_barcode/Widgets/History.dart';
import 'package:senior_barcode/Widgets/HistoryGenerated.dart';
import 'package:senior_barcode/data/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senior_barcode/Screens/generatelistscreen.dart';

// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:senior_barcode/Screens/ResultScreen.dart';
import 'package:hive/hive.dart';
import 'package:barcode/barcode.dart';
import 'dart:io';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:store_redirect/store_redirect.dart';

import 'GeneratedBarcodes/barcodes.dart';
import 'Scans/Scan.dart';

void buildBarcode(
  Barcode bc,
  String data, {
  String? filename,
  double? width,
  double? height,
  double? fontHeight,
}) {
  /// Create the Barcode
  final svg = bc.toSvg(
    data,
    width: width ?? 200,
    height: height ?? 80,
    fontHeight: fontHeight,
  );

  // Save the image
  filename ??= bc.name.replaceAll(RegExp(r'\s'), '-').toLowerCase();
  File('$filename.svg').writeAsStringSync(svg);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();

  if (kIsWeb) {
  } else {
    if (Platform.isAndroid) {
      // Android-specific code
      var appDir = await getApplicationDocumentsDirectory();
      Hive.init(appDir.path);
      if (kDebugMode) {
        print(appDir.path);
      }
    } else if (Platform.isIOS) {
      // iOS-specific code
    }
  }

  Hive.registerAdapter(ScanAdapter());
  Hive.registerAdapter(BarcodeAdapter());
  await Hive.openBox('mybox');
  // box.put('name', 'David');
  ScansDatabase db = ScansDatabase();
  BarcodesDatabase db2 = BarcodesDatabase();
  db.loadData();
  db2.loadData();
  if (kDebugMode) {
    print(db.scans);
  }

  // print('Name: ${box.get('name')}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // ignore: unused_field
  String _scanBarcode = 'Unknown';
  final _myBox = Hive.box('mybox');
  ScansDatabase db = ScansDatabase();
  BarcodesDatabase db2 = BarcodesDatabase();

  @override
  void initState() {
    // TODO: implement initState
    if (_myBox.get('SCANS') == null) {
      if (kDebugMode) {
        print('hi');
      }
      db.createInitialData();
    } else {

      db.loadData();
    }

    if (_myBox.get('BARCODES') == null) {
      if (kDebugMode) {
        print('hi');
      }
      db2.createInitialData();
    } else {

      db2.loadData();
    }
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        // ignore: avoid_print
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (barcodeScanRes != "" && barcodeScanRes != "-1") {
      db.scans?.add(
          Scan(id: 1, title: "Empty", content: barcodeScanRes, type: "Empty"));
      db.updateDatabase();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScanResult(result: db.scans?.last)),
        // MaterialPageRoute(builder: (context) => ScanResult(result:)),
      );
    }
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"),),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black54)),
                    onPressed: () => scanBarcodeNormal(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera,
                            size: 45,
                          ),
                        ),
                        Text(
                          "SCAN",
                          style: TextStyle(fontSize: 23),
                        )
                      ],
                    )),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black54),
                    ),
                    onPressed: () {
                      // AdmobService.createInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const History())
                          // MaterialPageRoute(builder: (context) => ScanResult(result:)),
                          );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.history,
                            size: 40,
                          ),
                        ),
                        Text(
                          "SCAN HISTORY",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    )),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black54),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HistoryGenerated()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.qr_code,
                            size: 40,
                          ),
                        ),
                        Text(
                          "GENERATED BARCODES",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    )),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black54),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const GenerateListScreen()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add,
                            size: 40,
                          ),
                        ),
                        Text(
                          "CREATE BARCODE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    )),
              ),

            ],
          ),
        ),
      ]),
    );
  }
}
