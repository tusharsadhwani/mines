import 'dart:math' show max;

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

    final newMineData = MineData(
      active: !mineData.active,
    );
    setState(() {
      matrix[index] = newMineData;
      recalculateSides();
    });
  }

  void recalculateSides() {
    print('recalculating sides...');
    for (int index = 0; index < matrix.length; index++) {
      final mineData = matrix[index];

      bool newLeft = false, newRight = false, newTop = false, newBottom = false;

      if (index - 1 >= 0) {
        newLeft = matrix[index - 1].active;
      }
      if (index + 1 < matrix.length) {
        newRight = matrix[index + 1].active;
      }
      if (index - cols >= 0) {
        newTop = matrix[index - cols].active;
      }
      if (index + cols < matrix.length) {
        newBottom = matrix[index + cols].active;
      }

      matrix[index] = MineData(
        active: mineData.active,
        left: newLeft,
        right: newRight,
        top: newTop,
        bottom: newBottom,
      );
    }

    // final isTopLeft = index == 0;
    // final isTopRight = index == cols - 1;

    // final isBottomLeft = index == rows * cols - 1;
    // final isBottomRight = index == (rows - 1) * cols;

    // if (index > 0) {
    //   newLeft = matrix[index - 1].active;
    // }
    // Basically need to do a check of each and every row and column I think,
    // A recursive approach might work as well but idk
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
    return
        // LayoutBuilder(
        //   builder: (_, constraints) => SizedBox(
        //     width: constraints.maxWidth - constraints.maxWidth % 10 + 1,
        //     child:
        AspectRatio(
      aspectRatio: 5 / 7,
      child: GridView.builder(
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
        //   ),
        // ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:minesweeper/models/mine_data.dart';

// import 'mine.dart';

// class Mines extends StatefulWidget {
//   @override
//   _MinesState createState() => _MinesState();
// }

// class _MinesState extends State<Mines> {
//   final rows = 7;
//   final cols = 5;

//   List<MineData> matrix;

//   void toggleMine(int index) {
//     final mineData = matrix[index];

//     final newMineData = MineData(
//       active: !mineData.active,
//     );
//     setState(() {
//       matrix[index] = newMineData;
//       recalculateSides();
//     });
//   }

//   void recalculateSides() {
//     print('recalculating sides...');
//     for (int index = 0; index < matrix.length; index++) {
//       final mineData = matrix[index];

//       bool newLeft = false, newRight = false, newTop = false, newBottom = false;

//       if (index - 1 >= 0) {
//         newLeft = matrix[index - 1].active;
//       }
//       if (index + 1 < matrix.length) {
//         newRight = matrix[index + 1].active;
//       }
//       if (index - cols >= 0) {
//         newTop = matrix[index - cols].active;
//       }
//       if (index + cols < matrix.length) {
//         newBottom = matrix[index + cols].active;
//       }

//       matrix[index] = MineData(
//         active: mineData.active,
//         left: newLeft,
//         right: newRight,
//         top: newTop,
//         bottom: newBottom,
//       );
//     }

//     // final isTopLeft = index == 0;
//     // final isTopRight = index == cols - 1;

//     // final isBottomLeft = index == rows * cols - 1;
//     // final isBottomRight = index == (rows - 1) * cols;

//     // if (index > 0) {
//     //   newLeft = matrix[index - 1].active;
//     // }
//     // Basically need to do a check of each and every row and column I think,
//     // A recursive approach might work as well but idk
//   }

//   @override
//   void initState() {
//     super.initState();
//     matrix = List<MineData>();

//     for (int i = 0; i < rows * cols; i++) {
//       matrix.add(MineData());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 5 / 7,
//       child: Wrap(
//         children: [
//           for (var index = 0; index < matrix.length; index++)
//             FractionallySizedBox(
//               widthFactor: 1 / cols,
//               child: AspectRatio(
//                 aspectRatio: 1,
//                 child: Mine(
//                   mineData: matrix[index],
//                   toggleMine: () => toggleMine(index),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
