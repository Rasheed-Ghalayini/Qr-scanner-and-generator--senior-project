// ignore_for_file: file_names

import 'package:senior_barcode/Widgets/History.dart';
import 'package:flutter/material.dart';


class DrawerItem extends StatelessWidget {
  const DrawerItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading:  const Icon(Icons.history),
      title: const Text('Item 1',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const History()),
        );
        //Navigator.pop(context);

      },
    );
  }
}
