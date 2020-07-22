class MineData {
  final bool active;

  bool left, right, top, bottom, topLeft, bottomLeft, topRight, bottomRight;

  MineData({
    this.active = false,
    this.left = false,
    this.right = false,
    this.top = false,
    this.bottom = false,
    this.topLeft = false,
    this.bottomLeft = false,
    this.topRight = false,
    this.bottomRight = false,
  });
}
