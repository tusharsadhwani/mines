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

  Map<String, MineAnimation> edges, corners;

  MineAnimationsChangeNotifier animations;

  @override
  void initState() {
    super.initState();

    top = MineAnimation(vsync: this, padding: widget.padding);
    left = MineAnimation(vsync: this, padding: widget.padding);
    right = MineAnimation(vsync: this, padding: widget.padding);
    bottom = MineAnimation(vsync: this, padding: widget.padding);
    edges = {'top': top, 'left': left, 'right': right, 'bottom': bottom};

    topLeft = MineAnimation(vsync: this, padding: widget.padding);
    topRight = MineAnimation(vsync: this, padding: widget.padding);
    bottomLeft = MineAnimation(vsync: this, padding: widget.padding);
    bottomRight = MineAnimation(vsync: this, padding: widget.padding);
    corners = {
      'topLeft': topLeft,
      'topRight': topRight,
      'bottomLeft': bottomLeft,
      'bottomRight': bottomRight,
    };

    animations = MineAnimationsChangeNotifier();

    edges.forEach((_, edge) => edge.addListener(animations.update));
    corners.forEach((_, corner) => corner.addListener(animations.update));
  }

  @override
  void didUpdateWidget(Mine oldWidget) {
    if (widget.mineData.active)
      driveEdgesAndCorners();
    else
      resetEdgesAndCorners();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    edges.forEach((_, edge) => edge.dispose());
    corners.forEach((_, corner) => corner.dispose());
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

  void driveEdges() {
    edges.forEach((edgeName, edge) {
      if (widget.mineData[edgeName])
        edge.reverse();
      else
        edge.forward();
    });
  }

  void driveCorners() {
    corners.forEach((cornerName, corner) {
      if (widget.mineData[cornerName])
        corner.forward();
      else
        corner.reverse();
    });
  }

  void driveEdgesAndCorners() {
    driveEdges();
    driveCorners();
  }

  void resetEdgesAndCorners() {
    edges.forEach((_, edge) => edge.reverse());
    corners.forEach((_, corner) => corner.reverse());
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
