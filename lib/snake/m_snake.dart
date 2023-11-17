enum SnakeCoordinate { one, two, three, four, five }

class SnakeBody {
  bool xHead;
  SnakePosition currentPos;
  // SnakePosition? previousPos;

  SnakeBody({required this.xHead, required this.currentPos});
}

class SnakePosition {
  int dx;
  int dy;

  SnakePosition({required this.dx, required this.dy});

  @override
  String toString() {
    return '$dx, $dy';
  }
}
