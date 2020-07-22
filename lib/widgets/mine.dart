import 'dart:math' show pi;

import 'package:flutter/material.dart';

import '../models/mine_data.dart';

class Mine extends StatefulWidget {
  final MineData mineData;
  final void Function() toggleMine;

  Mine({@required this.mineData, @required this.toggleMine});

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  bool topLeft, topRight, bottomLeft, bottomRight;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    topLeft = !widget.mineData.top && !widget.mineData.left;
    topRight = !widget.mineData.top && !widget.mineData.right;
    bottomLeft = !widget.mineData.bottom && !widget.mineData.left;
    bottomRight = !widget.mineData.bottom && !widget.mineData.right;
    // Now the issue is, corners need to take in account the topLeft ...
    // tiles as well, not just the adjacent edge data.
    //
    // Figure it out, champ.
  }

  @override
  void didUpdateWidget(Mine oldWidget) {
    topLeft = !widget.mineData.top && !widget.mineData.left;
    topRight = !widget.mineData.top && !widget.mineData.right;
    bottomLeft = !widget.mineData.bottom && !widget.mineData.left;
    bottomRight = !widget.mineData.bottom && !widget.mineData.right;

    if (oldWidget.mineData.active != widget.mineData.active) {
      if (widget.mineData.active)
        _animationController.forward();
      else {
        _animationController.value = 1;
        _animationController.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => ClipPath(
        clipper: CornerClipper(
            topLeft, topRight, bottomLeft, bottomRight, 10 * _animation.value),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            widget.mineData.left ? 0 : 10 * _animation.value,
            widget.mineData.top ? 0 : 10 * _animation.value,
            widget.mineData.right ? 0 : 10 * _animation.value,
            widget.mineData.bottom ? 0 : 10 * _animation.value,
          ),
          child: GestureDetector(
            onTap: widget.toggleMine,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: topLeft
                      ? Radius.circular(10 * _animation.value)
                      : Radius.zero,
                  topRight: topRight
                      ? Radius.circular(10 * _animation.value)
                      : Radius.zero,
                  bottomLeft: bottomLeft
                      ? Radius.circular(10 * _animation.value)
                      : Radius.zero,
                  bottomRight: bottomRight
                      ? Radius.circular(10 * _animation.value)
                      : Radius.zero,
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CornerClipper extends CustomClipper<Path> {
  double radius;
  bool topLeft, topRight, bottomLeft, bottomRight;
  CornerClipper(this.topLeft, this.topRight, this.bottomLeft, this.bottomRight,
      this.radius);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, topLeft ? radius : 0);
    if (topLeft)
      path.arcTo(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        pi / 2,
        -pi / 2,
        false,
      );

    path.lineTo(size.width - (topRight ? radius : 0), 0);
    if (topRight)
      path.arcTo(
        Rect.fromCircle(center: Offset(size.width, 0), radius: radius),
        pi,
        -pi / 2,
        false,
      );

    path.lineTo(size.width, size.height - (bottomRight ? radius : 0));
    if (bottomRight)
      path.arcTo(
        Rect.fromCircle(center: Offset(size.width, size.width), radius: radius),
        3 * pi / 2,
        -pi / 2,
        false,
      );

    path.lineTo(bottomLeft ? radius : 0, size.height);
    if (bottomLeft)
      path.arcTo(
        Rect.fromCircle(center: Offset(0, size.width), radius: radius),
        0,
        -pi / 2,
        false,
      );

    path.lineTo(0, topLeft ? radius : 0);
    return path;
  }

  @override
  bool shouldReclip(CornerClipper oldClipper) {
    return oldClipper.radius != this.radius;
  }
}
