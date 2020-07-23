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
  MyAnimation active,
      left,
      right,
      top,
      bottom,
      topLeft,
      topRight,
      bottomLeft,
      bottomRight;

  MyChangeNotifier animations;

  @override
  void initState() {
    super.initState();

    active = MyAnimation(this);
    top = MyAnimation(this);
    left = MyAnimation(this);
    right = MyAnimation(this);
    bottom = MyAnimation(this);
    topLeft = MyAnimation(this);
    topRight = MyAnimation(this);
    bottomLeft = MyAnimation(this);
    bottomRight = MyAnimation(this);

    animations = MyChangeNotifier();

    active.addListener(animations.update);
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
    if (widget.special) {
      print('updated dependencies!');
//       print('''
// top = ${widget.mineData.top}
// left = ${widget.mineData.left}
// right = ${widget.mineData.right}
// bottom = ${widget.mineData.bottom}''');
    }

    if (oldWidget.mineData.active != widget.mineData.active) {
      if (widget.mineData.active) {
        active.forward();
        if (!widget.mineData.top) top.forward();
        if (!widget.mineData.left) left.forward();
        if (!widget.mineData.right) right.forward();
        if (!widget.mineData.bottom) bottom.forward();
        if (widget.mineData.topLeft) topLeft.forward();
        if (widget.mineData.topRight) topRight.forward();
        if (widget.mineData.bottomLeft) bottomLeft.forward();
        if (widget.mineData.bottomRight) bottomRight.forward();
      } else {
        active.reverse();
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
    active.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topAndLeft = !widget.mineData.top && !widget.mineData.left;
    final topAndRight = !widget.mineData.top && !widget.mineData.right;
    final bottomAndLeft = !widget.mineData.bottom && !widget.mineData.left;
    final bottomAndRight = !widget.mineData.bottom && !widget.mineData.right;
    return AnimatedBuilder(
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
                  topLeft: topAndLeft
                      ? Radius.circular(active.animation.value)
                      : Radius.zero,
                  topRight: topAndRight
                      ? Radius.circular(active.animation.value)
                      : Radius.zero,
                  bottomLeft: bottomAndLeft
                      ? Radius.circular(active.animation.value)
                      : Radius.zero,
                  bottomRight: bottomAndRight
                      ? Radius.circular(active.animation.value)
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
  MyAnimation topLeft, topRight, bottomLeft, bottomRight;
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
    //TODO: probably needs refactoring
    return true;
  }
}

class MyAnimation {
  AnimationController animationController;
  Animation<double> animation;

  MyAnimation(TickerProvider parent) {
    animationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: parent,
    );

    animation = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
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

class MyChangeNotifier extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}
