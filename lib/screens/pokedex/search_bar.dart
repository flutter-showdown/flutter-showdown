import 'dart:async';

import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({this.placeholder, this.onSearch});
  final String placeholder;
  final Function(String) onSearch;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();
  Timer _debounce;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 400),
        () => widget.onSearch(_controller.text));
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: _controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _controller.clear();
            },
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1),
              borderRadius: BorderRadius.circular(20)),
          hintText: widget.placeholder,
        ),
      ),
    );
  }
}
