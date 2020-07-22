import 'dart:math' show pi;

import 'package:flutter/material.dart';

import '../models/mine_data.dart';

class Mine extends StatefulWidget {
  final MineData mineData;
  final void Function() toggleMine;

  //TODO: REMOVE
  final bool special;

  Mine({@required this.mineData, @required this.toggleMine, this.special});

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    //TODO: make funciton to spawn a new animation
    _animationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    // Now the issue is, corners need to take in account the topLeft ...
    // tiles as well, not just the adjacent edge data.
    //
    // Figure it out, champ.
  }

  @override
  void didUpdateWidget(Mine oldWidget) {
    if (widget.special) {
      print('updated dependencies!');
    }

    if (oldWidget.mineData.active != widget.mineData.active) {
      if (widget.mineData.active)
        _animationController.forward();
      else {
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
    final topLeft = !widget.mineData.top && !widget.mineData.left;
    final topRight = !widget.mineData.top && !widget.mineData.right;
    final bottomLeft = !widget.mineData.bottom && !widget.mineData.left;
    final bottomRight = !widget.mineData.bottom && !widget.mineData.right;
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => ClipPath(
        clipper: CornerClipper(
            // TODO: Implement separate animations for every single edge and verex?
            //  topLeftAnimation.value,
            // topRightAnimation.value,
            // bottomLeftAnimation.value,
            // bottomRightAnimation.value,
            // 10
            topLeft,
            topRight,
            bottomLeft,
            bottomRight,
            10 * _animation.value),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            !widget.mineData.left ? 10 * _animation.value : 0,
            !widget.mineData.top ? 10 * _animation.value : 0,
            !widget.mineData.right ? 10 * _animation.value : 0,
            !widget.mineData.bottom ? 10 * _animation.value : 0,
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
    //TODO: probably needs refactoring
    return true;
  }
}
