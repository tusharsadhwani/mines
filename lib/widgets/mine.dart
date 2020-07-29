import 'dart:math' show min, pi;

import 'package:flutter/material.dart';

import '../models/mine_data.dart';

class Mine extends StatefulWidget {
  final MineData mineData;
  final void Function() toggleMine;
  final double padding;

  Mine({
    @required this.mineData,
    @required this.toggleMine,
    @required this.padding,
  });

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> with TickerProviderStateMixin {
  MineAnimation top,
      left,
      right,
      bottom,
      topLeft,
      topRight,
      bottomLeft,
      bottomRight;
  MineAnimationsChangeNotifier animations;

  @override
  void initState() {
    super.initState();

    top = MineAnimation(vsync: this, padding: widget.padding);
    left = MineAnimation(vsync: this, padding: widget.padding);
    right = MineAnimation(vsync: this, padding: widget.padding);
    bottom = MineAnimation(vsync: this, padding: widget.padding);
    topLeft = MineAnimation(vsync: this, padding: widget.padding);
    topRight = MineAnimation(vsync: this, padding: widget.padding);
    bottomLeft = MineAnimation(vsync: this, padding: widget.padding);
    bottomRight = MineAnimation(vsync: this, padding: widget.padding);

    animations = MineAnimationsChangeNotifier();

    top.addListener(animations.update);
    left.addListener(animations.update);
    right.addListener(animations.update);
    bottom.addListener(animations.update);
    topLeft.addListener(animations.update);
    topRight.addListener(animations.update);
    bottomLeft.addListener(animations.update);
    bottomRight.addListener(animations.update);
  }

  @override
  void didUpdateWidget(Mine oldWidget) {
    if (oldWidget.mineData.active != widget.mineData.active) {
      if (widget.mineData.active) {
        if (!widget.mineData.top) top.forward();
        if (!widget.mineData.left) left.forward();
        if (!widget.mineData.right) right.forward();
        if (!widget.mineData.bottom) bottom.forward();
        if (widget.mineData.topLeft) topLeft.forward();
        if (widget.mineData.topRight) topRight.forward();
        if (widget.mineData.bottomLeft) bottomLeft.forward();
        if (widget.mineData.bottomRight) bottomRight.forward();
      } else {
        top.reverse();
        left.reverse();
        right.reverse();
        bottom.reverse();
        topLeft.reverse();
        topRight.reverse();
        bottomLeft.reverse();
        bottomRight.reverse();
      }
    } else {
      if (widget.mineData.active) {
        if (!widget.mineData.top) top.forward();
        if (!widget.mineData.left) left.forward();
        if (!widget.mineData.right) right.forward();
        if (!widget.mineData.bottom) bottom.forward();
        if (widget.mineData.topLeft) topLeft.forward();
        if (widget.mineData.topRight) topRight.forward();
        if (widget.mineData.bottomLeft) bottomLeft.forward();
        if (widget.mineData.bottomRight) bottomRight.forward();

        if (widget.mineData.top) top.reverse();
        if (widget.mineData.left) left.reverse();
        if (widget.mineData.right) right.reverse();
        if (widget.mineData.bottom) bottom.reverse();
        if (!widget.mineData.topLeft) topLeft.reverse();
        if (!widget.mineData.topRight) topRight.reverse();
        if (!widget.mineData.bottomLeft) bottomLeft.reverse();
        if (!widget.mineData.bottomRight) bottomRight.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    top.dispose();
    left.dispose();
    right.dispose();
    bottom.dispose();
    topLeft.dispose();
    topRight.dispose();
    bottomLeft.dispose();
    bottomRight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: animations,
        builder: (_, __) => ClipPath(
          clipper: CornerClipper(topLeft, topRight, bottomLeft, bottomRight),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              left.animation.value,
              top.animation.value,
              right.animation.value,
              bottom.animation.value,
            ),
            child: GestureDetector(
              onTap: widget.toggleMine,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      min(top.animation.value, left.animation.value),
                    ),
                    topRight: Radius.circular(
                      min(top.animation.value, right.animation.value),
                    ),
                    bottomLeft: Radius.circular(
                      min(bottom.animation.value, left.animation.value),
                    ),
                    bottomRight: Radius.circular(
                      min(bottom.animation.value, right.animation.value),
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CornerClipper extends CustomClipper<Path> {
  MineAnimation topLeft, topRight, bottomLeft, bottomRight;
  CornerClipper(this.topLeft, this.topRight, this.bottomLeft, this.bottomRight);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, topLeft.value);
    path.arcTo(
      Rect.fromCircle(center: Offset.zero, radius: topLeft.value),
      pi / 2,
      -pi / 2,
      false,
    );

    path.lineTo(size.width - topRight.value, 0);
    path.arcTo(
      Rect.fromCircle(
        center: Offset(size.width, 0),
        radius: topRight.value,
      ),
      pi,
      -pi / 2,
      false,
    );

    path.lineTo(
      size.width,
      size.height - bottomRight.value,
    );

    path.arcTo(
      Rect.fromCircle(
        center: Offset(size.width, size.width),
        radius: bottomRight.value,
      ),
      3 * pi / 2,
      -pi / 2,
      false,
    );

    path.lineTo(bottomLeft.value, size.height);
    path.arcTo(
      Rect.fromCircle(
        center: Offset(0, size.width),
        radius: bottomLeft.value,
      ),
      0,
      -pi / 2,
      false,
    );

    path.lineTo(0, topLeft.value);
    return path;
  }

  @override
  bool shouldReclip(CornerClipper oldClipper) {
    return true;
  }
}

class MineAnimation {
  AnimationController animationController;
  Animation<double> animation;
  final double padding;

  MineAnimation({TickerProvider vsync, this.padding}) {
    animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: vsync,
    );

    animation = Tween(begin: 0.0, end: padding).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutQuad,
      ),
    );
  }

  void dispose() {
    animationController.dispose();
  }

  double get value {
    return animation.value;
  }

  void forward() {
    animationController.forward();
  }

  void end() {
    animationController.value = 1;
  }

  void reverse() {
    animationController.reverse();
  }

  void addListener(void Function() change) {
    animationController.addListener(change);
  }
}

class MineAnimationsChangeNotifier extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}
