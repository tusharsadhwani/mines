import 'package:flutter/material.dart';

import '../models/mine_data.dart';

class Mine extends StatefulWidget {
  final MineData data;

  Mine(this.data);

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  bool clicked;

  @override
  void initState() {
    super.initState();
    clicked = false;
  }

  void _toggleMine() {
    setState(() {
      clicked = !clicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(clicked ? 10 : 0),
      child: GestureDetector(
        onTap: _toggleMine,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(clicked ? 10 : 0),
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
