import 'dart:io';

import '../utils/index.dart';
import '../utils/pair.dart';
import '../utils/utils.dart';


// Reprensents a MOVEABLE chunk
// InitialPos = Pos of @
// boxesPos = Pos of 0 in a row. Can be empty
class Chunk {
  Pair<int, int> initialPos;
  List<Pair<int, int>> boxesPos;

  Chunk(this.initialPos, this.boxesPos);
}

class Day15 extends GenericDay {
  Day15() : super(15);

  static const dirTop = '^';
  static const dirLeft = '<';
  static const dirRight = '>';
  static const dirBottom = 'v';

  @override
  Pair<List<List<String>>, List<String>> parseInput({bool expand = false}) {
    // final file = File('input/aoc15x.txt');
    final file = File('input/aoc15.txt');

    try {
      final content = file.readAsStringSync();
      final groups = content.split('\n\n');

      final map = stringToStringMap(groups[0]);
      final directions = groups[1].split('\n').map((e) {
        if (expand) {
          if (e == '#') return '##';
          if (e == 'O') return '[]';
          if (e == '.') return '..';
          if (e == '@') return '@.';
        } else {
          return e;
        }
      }).join().split('');

      return Pair(map, directions);
    } catch (e) {
      return Pair([], []);
    }
  }

  Pair<int, int> getUserPos(List<List<String>> map) {
    for (var y = 0; y < map.length; y++) {
      for (var x = 0; x < map[y].length; x++) {
        if (map[y][x] == '@') {
          return Pair(y, x);
        }
      }
    }
    return Pair(-1, -1);
  }

  // Move the whole chunk, starting by the end of the chunk
  // If the end of the chunk cannot move, abort
  void updateMapWithChunk(List<List<String>> map, Chunk chunk, String dir) {
    final userPos = chunk.initialPos;
    final userY = userPos.first;
    final userX = userPos.second;
    final boxes = chunk.boxesPos;

    if (dir == dirRight) {
      for (var i = boxes.length - 1; i >= 0; i--) {
        final boxPos = chunk.boxesPos[i];
        final boxY = boxPos.first;
        final boxX = boxPos.second;

        if (map[boxY][boxX + 1] == '#') {
          print('Cannot move chunk right, aborting');
          return;
        } else {
          map[boxY][boxX + 1] = 'O';
        }
      }
      if (map[userY][userX + 1] != '#') {
        map[userY][userX + 1] = '@';
        map[userY][userX] = '.';
      }
    } else if (dir == dirTop) {
      for (var i = boxes.length - 1; i >= 0; i--) {
        final boxPos = chunk.boxesPos[i];
        final boxY = boxPos.first;
        final boxX = boxPos.second;

        if (map[boxY - 1][boxX] == '#') {
          print('Cannot move chunk top, aborting');
          return;
        } else {
          map[boxY - 1][boxX] = 'O';
        }
      }

      if (map[userY - 1][userX] != '#') {
        map[userY - 1][userX] = '@';
        map[userY][userX] = '.';
      }
    } else if (dir == dirBottom) {
      for (var i = boxes.length - 1; i >= 0; i--) {
        final boxPos = chunk.boxesPos[i];
        final boxY = boxPos.first;
        final boxX = boxPos.second;

        if (map[boxY + 1][boxX] == '#') {
          print('Cannot move chunk bottom, aborting');
          return;
        } else {
          map[boxY + 1][boxX] = 'O';
        }
      }
      if (map[userY + 1][userX] != '#') {
        map[userY + 1][userX] = '@';
        map[userY][userX] = '.';
      }
    } else if (dir == dirLeft) {
      for (var i = boxes.length - 1; i >= 0; i--) {
        final boxPos = chunk.boxesPos[i];
        final boxY = boxPos.first;
        final boxX = boxPos.second;

        if (map[boxY][boxX - 1] == '#') {
          print('Cannot move chunk left, aborting');
          return;
        } else {
          map[boxY][boxX - 1] = 'O';
        }
      }

      if (map[userY][userX - 1] != '#') {
        map[userY][userX - 1] = '@';
        map[userY][userX] = '.';
      }
    }
  }

  Chunk getNextChunk(List<List<String>> map, String dir) {
    final userPos = getUserPos(map);
    final chunk = Chunk(userPos, []);
    final userY = userPos.first;
    final userX = userPos.second;

    if (dir == dirTop) {
      if (map[userY - 1][userX] == '.' || map[userY - 1][userX] == '#') {
        return chunk;
      }

      for (var y = userY - 1; y >= 0; y--) {
        // End of the chunk
        if (map[y][userX] == '.' || map[y][userX] == '#') {
          return chunk;
        }

        if (map[y][userX] == 'O') {
          chunk.boxesPos.add(Pair(y, userX));
        }
      }
    } else if (dir == dirBottom) {
      if (map[userY + 1][userX] == '.' || map[userY + 1][userX] == '#') {
        return chunk;
      }

      for (var y = userY + 1; y < map.length; y++) {
        // End of the chunk
        if (map[y][userX] == '.' || map[y][userX] == '#') {
          return chunk;
        }

        if (map[y][userX] == 'O') {
          chunk.boxesPos.add(Pair(y, userX));
        }
      }
    } else if (dir == dirLeft) {
      if (map[userY][userX - 1] == '.' || map[userY][userX - 1] == '#') {
        return chunk;
      }
      for (var x = userX - 1; x >= 0; x--) {
        // End of the chunk
        if (map[userY][x] == '.' || map[userY][x] == '#') {
          return chunk;
        }

        if (map[userY][x] == 'O') {
          chunk.boxesPos.add(Pair(userY, x));
        }
      }
    } else if (dir == dirRight) {
      if (map[userY][userX + 1] == '.' || map[userY][userX + 1] == '#') {
        return chunk;
      }

      for (var x = userX + 1; x < map[userY].length; x++) {
        // End of the chunk
        if (map[userY][x] == '.' || map[userY][x] == '#') {
          return chunk;
        }

        if (map[userY][x] == 'O') {
          chunk.boxesPos.add(Pair(userY, x));
        }
      }
    }

    return chunk;
  }

  @override
  int solvePart1() {
    // All pos here are y;x not x;y. May be confusing..
    final input = parseInput();
    final map = input.first;

    for (var i = 0; i < input.second.length; i++) {
      final currentDir = input.second[i];
      final chunk = getNextChunk(map, currentDir);
      updateMapWithChunk(map, chunk, currentDir);
    }

    // Print the map content
    var count = 0;
    // Count the 'O' in the map where each O value is y*100 + x
    for (var y = 0; y < map.length; y++) {
      for (var x = 0; x < map[y].length; x++) {
        if (map[y][x] == 'O') {
          count += y * 100 + x;
        }
      }
    }

    return count;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
