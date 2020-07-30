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

  bool operator [](String key) {
    switch (key) {
      case 'top':
        return top;
      case 'left':
        return left;
      case 'right':
        return right;
      case 'bottom':
        return bottom;
      case 'topLeft':
        return topLeft;
      case 'bottomLeft':
        return bottomLeft;
      case 'topRight':
        return topRight;
      case 'bottomRight':
        return bottomRight;
      default:
        throw NoSuchMethodError;
    }
  }
}
