import 'dart:io';

import '../utils/index.dart';
import '../utils/utils.dart';
import 'dart:math' as math;

class CurrentPosition {
  final int x;
  final int y;
  final String? direction;

  CurrentPosition(this.x, this.y, this.direction);

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (other is CurrentPosition) {
      return x == other.x && y == other.y;
    }
    return false;
  }
}


class Day16 extends GenericDay {
  Day16() : super(16);

  static const dirTop = '^';
  static const dirLeft = '<';
  static const dirRight = '>';
  static const dirBottom = 'v';
  static const directions = [dirTop, dirRight, dirLeft, dirBottom];

  @override
  List<List<String>> parseInput() {
    final file = File('input/aoc16.txt');
    final content = file.readAsStringSync();
    return stringToStringMap(content);
  }


  List<int> getDirectionsModifiers(String projectionDir) {
    if (projectionDir == dirTop) {
      return [-1, 0];
    } else if (projectionDir == dirBottom) {
      return [1, 0];
    } else if (projectionDir == dirLeft) {
      return [0, -1];
    } else if (projectionDir == dirRight) {
      return [0, 1];
    }
    return [];
  }

  Pos getLetterIndex(List<List<String>> map, String letter) {
    for (var y = 0; y < map.length; y++) {
      for (var x = 0; x < map[y].length; x++) {
        if (map[y][x] == letter) {
          return Pos(x, y);
        }
      }
    }
    return const Pos(-1, -1);
  }


  @override
  int solvePart1() {
    final input = parseInput();

    return 0;
  }

  @override
  int solvePart2() {

    return 0;
  }
}

