import 'dart:io';

import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  List<List<int>> parseInput() {
    final file = File('input/aoc10.txt');
    try {
      final content = file.readAsStringSync();
      final lines = content.split('\n');
      return lines
          .map(
            (e) => e.split('').map(int.parse).toList(),
          )
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  static const List<List<int>> directions = [
    [0, -1],
    [-1, 0],
    [0, 1],
    [1, 0],
  ];

  List<List<int>> getStartPositions(List<List<int>> data) {
    final positions = <List<int>>[];
    for (var row = 0; row < data.length; row++) {
      for (var col = 0; col < data[0].length; col++) {
        if (data[row][col] == 0) {
          positions.add([row, col]);
        }
      }
    }
    return positions;
  }

  bool isInBounds(List<List<int>> data, int row, int col) {
    return row >= 0 && row < data.length && col >= 0 && col < data[0].length;
  }

  int countReachable(List<List<int>> data, int startRow, int startCol) {
    // Recursive function to count the number of unique paths
    int countPaths(
      List<List<int>> data,
      int row,
      int col,
      Set<String> visited,
    ) {
      if (data[row][col] == 9) {
        return 1;
      }

      // Check all the values around the current index
      // CHeck if out of bounds
      // CHeck if visited
      // Check if the value is the next value in the sequence
      // For each element valid, add it to the visited array and re-call
      return directions
          .map((dir) => [row + dir[0], col + dir[1]])
          .where(
            (pos) =>
                !visited.contains('${pos[0]},${pos[1]}') &&
                isInBounds(data, pos[0], pos[1]) &&
                data[pos[0]][pos[1]] == data[row][col] + 1,
          )
          .fold(0, (count, pos) {
        visited.add('${pos[0]},${pos[1]}');
        return count + countPaths(data, pos[0], pos[1], visited);
      });
    }

    return countPaths(data, startRow, startCol, {'$startRow,$startCol'});
  }

  int countUniquePaths(
    List<List<int>> data,
    int row,
    int col,
    List<List<int?>> dp,
  ) {
    if (data[row][col] == 9) {
      dp[row][col] = 1;
    }
    if (dp[row][col] != null) {
      return dp[row][col]!;
    }

    dp[row][col] = directions
        .map((dir) => [row + dir[0], col + dir[1]])
        .where(
          (pos) =>
              isInBounds(data, pos[0], pos[1]) &&
              data[pos[0]][pos[1]] == data[row][col] + 1,
        )
        .fold(
          0,
          (count, pos) => count! + countUniquePaths(data, pos[0], pos[1], dp),
        );

    return dp[row][col]!;
  }

  @override
  int solvePart1() {
    final input = parseInput();
    final startPositions = getStartPositions(input);

    return startPositions.fold(0, (count, pos) {
      return count + countReachable(input, pos[0], pos[1]);
    });
  }

  @override
  int solvePart2() {
    final input = parseInput();
    final startPositions = getStartPositions(input);
    final pathsTaken = input.map((row) => List<int?>.filled(row.length, null)).toList();

    return startPositions.fold(0, (count, pos) {
      return count + countUniquePaths(input, pos[0], pos[1], pathsTaken);
    });
  }
}
