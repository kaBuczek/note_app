import 'package:flutter/material.dart';
import 'package:note_app/filter_state.dart';
import 'package:note_app/note.dart';

class SearchBar extends StatefulWidget {
  const SearchBar(
      {Key? key,
      required this.context,
      required this.refresh,
      required this.filterState,
      required this.searchController})
      : super(key: key);

  final BuildContext context;
  final Function refresh;
  final FilterState filterState;
  final TextEditingController searchController;

  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          color: Colors.grey[400],
        ),
        child: Center(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Search🔎',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            controller: widget.searchController,
          ),
        ));
  }
}
