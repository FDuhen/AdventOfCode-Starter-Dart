import 'dart:collection';
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
    // final file = File('input/aoc15xx.txt');
    // final file = File('input/aoc15x.txt');
    final file = File('input/aoc15.txt');

    try {
      final content = file.readAsStringSync();
      final groups = content.split('\n\n');

      final map = stringToStringMap(groups[0]).map((f) => f.map((e) {
        if (expand) {
          if (e == '#') return '##';
          if (e == 'O') return '[]';
          if (e == '.') return '..';
          if (e == '@') return '@.';

          return e;
        } else {
          return e;
        }
      }).join().split('')).toList();
      final directions = groups[1].split('\n').join().split('');

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
          return;
        } else {
          map[boxY][boxX + 1] = map[boxY][boxX];
          map[boxY][boxX] = '.';
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
          return;
        } else {
          map[boxY - 1][boxX] = map[boxY][boxX];
          map[boxY][boxX] = '.';
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
          return;
        } else {
          map[boxY + 1][boxX] = map[boxY][boxX];
          map[boxY][boxX] = '.';
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
          return;
        } else {
          map[boxY][boxX - 1] = map[boxY][boxX];
          map[boxY][boxX] = '.';
        }
      }

      if (map[userY][userX - 1] != '#') {
        map[userY][userX - 1] = '@';
        map[userY][userX] = '.';
      }
    }
  }

  bool canMoveWholeChunk(List<List<String>> map, Chunk chunk, String dir) {
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
          return false;
        }
      }
      if (map[userY][userX + 1] == '#') {
        return false;
      }
    } else if (dir == dirTop) {
      for (var i = boxes.length - 1; i >= 0; i--) {
        final boxPos = chunk.boxesPos[i];
        final boxY = boxPos.first;
        final boxX = boxPos.second;

        if (map[boxY - 1][boxX] == '#') {
          return false;
        }
      }
      if (map[userY - 1][userX] == '#') {
        return false;
      }
    } else if (dir == dirBottom) {
      for (var i = boxes.length - 1; i >= 0; i--) {
        final boxPos = chunk.boxesPos[i];
        final boxY = boxPos.first;
        final boxX = boxPos.second;

        if (map[boxY + 1][boxX] == '#') {
          return false;
        }
      }
      if (map[userY + 1][userX] == '#') {
        return false;
      }
    } else if (dir == dirLeft) {
      for (var i = boxes.length - 1; i >= 0; i--) {
        final boxPos = chunk.boxesPos[i];
        final boxY = boxPos.first;
        final boxX = boxPos.second;

        if (map[boxY][boxX - 1] == '#') {
          return false;
        }
      }
      if (map[userY][userX - 1] == '#') {
        return false;
      }
    }

    return true;
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

    // return 0;
    return count;
  }

  List<int> getDirections(String pushDir) {
    if (pushDir == dirTop) {
      return [-1, 0];
    } else if (pushDir == dirBottom) {
      return [1, 0];
    } else if (pushDir == dirLeft) {
      return [0, -1];
    } else if (pushDir == dirRight) {
      return [0, 1];
    }
    return [];
  }

  @override
  int solvePart2() {// All pos here are y;x not x;y. May be confusing..
    final input = parseInput(expand: true);
    // final input = parseInput(expand: false);
    final map = input.first;

    for (var i = 0; i < input.second.length; i++) {
      final currentDir = input.second[i];
      final currentPos = getUserPos(map);

      // BFS setup
      final queue = Queue<List<int>>();
      final visited = <Pos>[];

      // Start BFS from '@'
      queue.add([currentPos.first, currentPos.second]);
      visited.add(Pos(currentPos.first, currentPos.second));

      // Store Pos of connected brackets
      final connectedBrackets = <List<int>>[];

      while (queue.isNotEmpty) {
        final current = queue.removeFirst();
        final x = current[0];
        final y = current[1];

        // Check if this Pos is a '[' or ']'
        if (map[x][y] == '[' || map[x][y] == ']') {
          connectedBrackets.add([x, y]);
        }

        // final queueDir = Queue<List<int>>();
        // queueDir.add(getDirections(currentDir));
        // while (queueDir.isNotEmpty) {
          // Explore neighbors
          final direction = getDirections(currentDir);
          final newX =  x + direction[0];
          final newY = y + direction[1];

          // Check bounds
          if (newX < 0 || newX >= map.length || newY < 0 || newY >= map[0].length) {
            continue;
          }

          // Only consider cells that are valid: `[`, `]`, or empty `.`
          if ((map[newX][newY] == '[' || map[newX][newY] == ']' || map[newX][newY] == '.') && !visited.contains(Pos(newX, newY))) {
            // If the checked element is not the first move of @ with a dot after we add it to he list to check
            if (map[newX][newY] != '.') {
              queue.add([newX, newY]);
              visited.add(Pos(newX, newY));
            }
            if (map[newX][newY] == '[') {
              if (currentDir == dirTop || currentDir == dirBottom) {
                queue.add([newX, newY+1]);
                visited.add(Pos(newX, newY+1));
              }
            } else if (map[newX][newY] == ']') {
              if (currentDir == dirTop || currentDir == dirBottom) {
                queue.add([newX, newY-1]);
                visited.add(Pos(newX, newY-1));
              }
            }
          }

          // Break after first iteration if on position of the @
          // if (x == currentPos.first && y == currentPos.second && map[newX][newY] == '.') {
          //   break outer;
          // }
        // }
      }

      final chunk = Chunk(currentPos, connectedBrackets.map((e) => Pair(e[0], e[1])).toList());
      if (canMoveWholeChunk(map, chunk, currentDir)) {
        print('Can move chunk');
        updateMapWithChunk(map, chunk, currentDir);
      }


      print('Current dir: $currentDir');

      // Print map
      for (var i = 0; i < map.length; i++) {
        print(map[i].join());
      }
    }

    // Print the map content
    var count = 0;
    // Count the 'O' in the map where each O value is y*100 + x
    for (var y = 0; y < map.length; y++) {
      for (var x = 0; x < map[y].length; x++) {
        if (map[y][x] == '[') {
          count += y * 100 + x;
        }
      }
    }

    return count;
  }
}
