import 'dart:math';

/// Helper class for to 2d and 3d calculations
/// like distance and relative positions.
class Point {
  num _x, _y;
  late int _hash;

  num get xn => _x;
  num get yn => _y;
  int get xi => _x.toInt();
  int get yi => _y.toInt();

  // A point in space. Can be either be discrete point or floating points
  Point(this._x, this._y) {
    _hash = Object.hash(_x, _y);
  }

  @override
  bool operator==(Object o) => o is Point && _x == o._x && _y == o._y;
  @override
  int get hashCode => _hash;
  @override
  String toString() => 'P($_x, $_y)';

  Point operator+(Point o) => Point(_x + o._x, _y + o._y);
  Point operator-(Point o) => Point(_x - o._x, _y - o._y);
  Point operator*(num o) => Point(_x * o, _y * o);

  // Euclidian distance between two points
  num euclidianDist(Point o) => sqrt(pow(_x- o._x, 2) + pow(_y - o._y, 2));

  // Manhattan distance between two points
  int manhattanDist(Point o) => ((_x - o._x).abs() + (_y - o._y).abs()).toInt();
}