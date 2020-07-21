import 'package:flutter/material.dart';
import 'package:minesweeper/models/mine_data.dart';

import 'mine.dart';

class Mines extends StatefulWidget {
  @override
  _MinesState createState() => _MinesState();
}

class _MinesState extends State<Mines> {
  final rows = 5;
  final cols = 7;

  List<MineData> matrix;

  @override
  void initState() {
    super.initState();
    matrix = List<MineData>();

    for (int i = 0; i < rows * cols; i++) {
      matrix.add(MineData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
      itemCount: matrix.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: rows,
      ),
      itemBuilder: (_, index) => AspectRatio(
        aspectRatio: 1,
        child: Mine(matrix[index]),
      ),
    );
  }
}
