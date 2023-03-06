import 'package:flutter/material.dart';

class SearchBarAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget action;
  bool isSearching;
  final Function(String) onChange;
  SearchBarAppBar({Key? key, required this.title,required this.action,required this.isSearching,required this.onChange}) : super(key: key);

  @override
  _SearchBarAppBarState createState() => _SearchBarAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchBarAppBarState extends State<SearchBarAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: !widget.isSearching
          ? Text(widget.title)
          : TextField(
        // controller: widget.controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Search...",
          border: InputBorder.none,
        ),
        onChanged: widget.onChange
      ),
      actions: <Widget>[
        widget.action,
        if (widget.isSearching)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                widget.isSearching = false;
                // widget.controller.clear();
              });
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                widget.isSearching = true;
              });
            },
          ),
      ],
    );
  }
}