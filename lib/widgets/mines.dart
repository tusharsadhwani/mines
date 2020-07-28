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

  List<List<MineData>> matrix;

  void toggleMine(int row, int col) {
    final mineData = matrix[row][col];

    final newMineData = MineData(
      active: !mineData.active,
    );
    setState(() {
      matrix[row][col] = newMineData;
      recalculateSides();
    });
  }

  void recalculateSides() {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final mineData = matrix[row][col];

        var newTop = false,
            newLeft = false,
            newRight = false,
            newBottom = false,
            newTopLeft = false,
            newTopRight = false,
            newBottomLeft = false,
            newBottomRight = false;

        bool topExists = row > 0;
        bool leftExists = col > 0;
        bool rightExists = col + 1 < cols;
        bool bottomExists = row + 1 < rows;
        if (topExists) {
          newTop = matrix[row - 1][col].active;
        }
        if (leftExists) {
          newLeft = matrix[row][col - 1].active;
        }
        if (rightExists) {
          newRight = matrix[row][col + 1].active;
        }
        if (bottomExists) {
          newBottom = matrix[row + 1][col].active;
        }

        if (topExists && leftExists && newTop && newLeft) {
          newTopLeft = !matrix[row - 1][col - 1].active;
        }
        if (topExists && rightExists && newTop && newRight) {
          newTopRight = !matrix[row - 1][col + 1].active;
        }
        if (bottomExists && leftExists && newBottom && newLeft) {
          newBottomLeft = !matrix[row + 1][col - 1].active;
        }
        if (bottomExists && rightExists && newBottom && newRight) {
          newBottomRight = !matrix[row + 1][col + 1].active;
        }

        matrix[row][col] = MineData(
          active: mineData.active,
          top: newTop,
          left: newLeft,
          right: newRight,
          bottom: newBottom,
          topLeft: newTopLeft,
          topRight: newTopRight,
          bottomLeft: newBottomLeft,
          bottomRight: newBottomRight,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    matrix = List<List<MineData>>();

    for (int i = 0; i < rows; i++) {
      matrix.add([]);
      for (int j = 0; j < cols; j++) {
        matrix[i].add(MineData());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 5 / 7,
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols),
          itemCount: rows * cols,
          itemBuilder: (_, index) {
            final row = index ~/ cols;
            final col = index % cols;
            // OverflowBox is a workaround, can be removed once the
            // bug in flutter engine is fixed:
            // https://stackoverflow.com/a/63099805/6573778
            return LayoutBuilder(
              builder: (_, constraints) => OverflowBox(
                maxHeight: constraints.maxHeight + 1.5,
                maxWidth: constraints.maxWidth + 1.5,
                child: Mine(
                  mineData: matrix[row][col],
                  toggleMine: () => toggleMine(row, col),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
