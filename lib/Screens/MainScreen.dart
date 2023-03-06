import 'package:flutter/material.dart';
import 'package:senior_barcode/main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // use Colors.transparent to show  background image
      appBar: AppBar(
        title: const Text("Barcode Scanner"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          //TODO:: uncomment to use image from network
          Image.network(
            'https://cdn.pixabay.com/photo/2021/08/18/19/23/background-6556394_960_720.jpg',
            fit: BoxFit.fill,
            errorBuilder: (context, _, __) {
              return Image.asset(
                'assets/images/wp3404268.jpg',
                fit: BoxFit.cover,
              );
            },
          ),
          //TODO:: uncomment to use image from assets
          /*Image.asset(
            'assets/images/image1.png',
            fit: BoxFit.cover, // change the fit of the picture.
          ),*/
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to QR Buddy',
                  style: const TextStyle(fontSize: 24.0),
                ),
                const SizedBox(
                  height: 14.0,
                ),
                const Text(
                  'Where you can scan, generate and save your barcodes',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(
                  height: 14.0,
                ),
                const Text(
                  ' ',
                  style: const TextStyle(fontSize: 24.0),
                ),
                const SizedBox(
                  height: 14.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()));
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 24),
                    child: Text(
                      "BEGIN",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
