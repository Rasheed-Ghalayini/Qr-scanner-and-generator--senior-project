import 'package:flutter/material.dart';


import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GenerateListItem extends StatelessWidget {
  final Color color;
  final String text;
  final Widget icon;
  final Widget onclick;
  const GenerateListItem({Key? key,required this.color,required this.text,required this.icon,required this.onclick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 2,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
          ),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => onclick)
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: icon,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18,),
              )
            ],
          )),
    );
  }
}
    