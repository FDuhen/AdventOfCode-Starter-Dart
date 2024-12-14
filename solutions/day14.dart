import 'dart:io';

import '../utils/index.dart';
import '../utils/pair.dart';

const int xLength = 101;
const int yLength = 103;

class BotPosition {
  BotPosition(this.currentPosition, this.verlocity);

  Pair<int, int> currentPosition;
  Pair<int, int> verlocity;

  int calculateNewPos(int current, int velocity, int maxPos) {
    var newPos = current + velocity;
    while (newPos >= maxPos) {
      newPos = newPos - maxPos;
    }
    while (newPos < 0) {
      newPos = maxPos + newPos;
    }

    return newPos;
  }

  void move() {
    final newX = calculateNewPos(currentPosition.first, verlocity.first, xLength);
    final newY = calculateNewPos(currentPosition.second, verlocity.second, yLength);

    currentPosition = Pair(newX, newY);
  }
}

class Day14 extends GenericDay {
  Day14() : super(14);

  @override
  List<BotPosition> parseInput() {
    // p=39,92 v=-59,-34
    // p=16,24 v=43,4

    final file = File('input/aoc14.txt');
    final regex = RegExp(r'p=(-?\d+),(-?\d+)\s+v=(-?\d+),(-?\d+)');

    try {
      final content = file.readAsStringSync();
      final lines = content.split('\n');
      final positions = <BotPosition>[];

      for (final line in lines) {
        final match = regex.firstMatch(line);
        if (match != null) {
          final currentPosition = Pair(int.parse(match.group(1)!), int.parse(match.group(2)!));
          final velocity = Pair(int.parse(match.group(3)!), int.parse(match.group(4)!));
          positions.add(BotPosition(currentPosition, velocity));
        } else {
          throw Exception('Invalid input');
        }
      }

      return positions;
    } catch (e) {
      return [];
    }
  }

  @override
  int solvePart1() {
    const maxIterations = 100;
    final positions = parseInput();
    for (var i = 0; i < maxIterations; i++) {
      for (var j = 0; j < positions.length; j++) {
        positions[j].move();
      }
    }

    final grid = List.generate(xLength, (index) => List.generate(yLength, (index) => 0));
    for (var i = 0; i < positions.length; i++) {
      final gridVal = grid[positions[i].currentPosition.first][positions[i].currentPosition.second];
      grid[positions[i].currentPosition.first][positions[i].currentPosition.second] = gridVal+1;
    }

    final quadrantLimitX = grid.length ~/ 2;
    final quadrantLimitY = grid[0].length ~/ 2;


    return countQuadrantValues(0, 0, quadrantLimitX, quadrantLimitY, grid) *
        countQuadrantValues(quadrantLimitX+1, 0, grid.length, quadrantLimitY, grid) *
        countQuadrantValues(0, quadrantLimitY+1, quadrantLimitX, grid[0].length, grid) *
        countQuadrantValues(quadrantLimitX+1, quadrantLimitY+1, grid.length, grid[0].length, grid);
  }

  int countQuadrantValues(int startX, int startY, int maxX, int maxY, List<List<int>> grid) {
    var count = 0;
    for (var x = startX; x < maxX; x++) {
      for (var y = startY; y < maxY; y++) {
        count += grid[x][y];
      }
    }
    return count;
  }

  @override
  int solvePart2() {
    // HAHAHA YOU FCKIN BITCHES
    final file = File('input/result.txt');

    const maxIterations = 10000;
    final positions = parseInput();
    for (var i = 0; i < maxIterations; i++) {
      for (var j = 0; j < positions.length; j++) {
        positions[j].move();
      }

      var buffer = '';
      var shouldWrite = false;
      for (var x = 0; x < xLength; x++) {
        var countInARow = 0;
        for (var y = 0; y < yLength; y++) {
          var found = false;
          for (var k = 0; k < positions.length; k++) {
            if (positions[k].currentPosition.first == x && positions[k].currentPosition.second == y) {
              found = true;
              break;
            }
          }

          if (found) {
            if (buffer.isNotEmpty && buffer.endsWith('#')) {
              countInARow++;
              if (countInARow > 15) {
                shouldWrite = true;
              }
            }
            buffer += '#';

          } else {
            buffer += '.';
            // print('.');
          }
        }
        // print(line);
        buffer += '\n';
      }

      if (shouldWrite) {
        file.writeAsStringSync('************************************\n', mode: FileMode.append);
        file.writeAsStringSync('****************Iteration $i*********\n', mode: FileMode.append);
        file.writeAsStringSync('************************************\n', mode: FileMode.append);
        file.writeAsStringSync('$buffer', mode: FileMode.append);
        shouldWrite = false;
      }
    }


    // Visual chekc in result.txt lmao
    return 0;
  }
}

