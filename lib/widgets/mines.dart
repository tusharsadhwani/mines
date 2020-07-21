import 'package:flutter/material.dart';
import 'package:minesweeper/models/mine_data.dart';

import 'mine.dart';

class Mines extends StatefulWidget {
  @override
  _MinesState createState() => _MinesState();
}

class _MinesState extends State<Mines> {
  final rows = 7;
  final cols = 5;

  List<MineData> matrix;

  void toggleMine(int index) {
    final mineData = matrix[index];

    var newLeft, newRight, newTop, newBottom;

    final isTopLeft = index == 0;
    final isTopRight = index == cols - 1;

    final isBottomLeft = index == rows * cols - 1;
    final isBottomRight = index == (rows - 1) * cols;

    // if (index > 0) {
    //   newLeft = matrix[index - 1].active;
    // }
    // Basically need to do a check of each and every row and column I think,
    // A recursive approach might work as well but idk

    final newMineData = MineData(
      active: !mineData.active,
      left: !mineData.left,
    );
    setState(() {
      matrix[index] = newMineData;
    });
  }

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
        crossAxisCount: cols,
      ),
      itemBuilder: (_, index) => AspectRatio(
        aspectRatio: 1,
        child: Mine(
          mineData: matrix[index],
          toggleMine: () => toggleMine(index),
        ),
      ),
    );
  }
}
