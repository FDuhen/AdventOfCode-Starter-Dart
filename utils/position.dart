// Easing the positions comparison
import 'package:meta/meta.dart';

@immutable
class Pos {
  const Pos(this.x, this.y);

  final int x;
  final int y;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Pos &&
              runtimeType == other.runtimeType &&
              x == other.x &&
              y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
