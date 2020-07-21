import 'package:flutter/material.dart';

import '../models/mine_data.dart';

class Mine extends StatelessWidget {
  final MineData mineData;
  final void Function() toggleMine;

  Mine({
    @required this.mineData,
    @required this.toggleMine,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: mineData.active
          ? EdgeInsets.fromLTRB(
              mineData.left ? 0 : 10,
              mineData.top ? 0 : 10,
              mineData.right ? 0 : 10,
              mineData.bottom ? 0 : 10,
            )
          : EdgeInsets.zero,
      child: GestureDetector(
        onTap: toggleMine,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: mineData.active && !mineData.top && !mineData.left
                  ? Radius.circular(10)
                  : Radius.zero,
              topRight: mineData.active && !mineData.top && !mineData.right
                  ? Radius.circular(10)
                  : Radius.zero,
              bottomLeft: mineData.active && !mineData.bottom && !mineData.left
                  ? Radius.circular(10)
                  : Radius.zero,
              bottomRight:
                  mineData.active && !mineData.bottom && !mineData.right
                      ? Radius.circular(10)
                      : Radius.zero,
            ),
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
