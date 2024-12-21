import 'dart:io';

import '../utils/index.dart';
import '../utils/pair.dart';

enum Directions {
  up(0, -1, '^'),
  down(0, 1, 'v'),
  left(-1, 0, '<'),
  right(1, 0, '>');

  const Directions(this.x, this.y, this.symbol);

  final int x;
  final int y;
  final String symbol;
}

class Step {
  final String from;
  final String to;
  final int depth;

  Step(this.from, this.to, this.depth);


  @override
  int get hashCode {
    return from.hashCode ^ depth.hashCode ^ to.hashCode;
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Step &&
      other.from == from &&
      other.to == to &&
      other.depth == depth;
  }

  @override
  String toString() {
    return 'Step{from: $from, to: $to, depth: $depth}';
  }
}
class Day21 extends GenericDay {
  static const maxVal = 99999999999;

  Day21() : super(21);

  final List<List<String>> _numGrid = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    ['_', '0', 'A'],
  ];

  final List<List<String>> _dirGrid = [
    ['_', '^', 'A'],
    ['<', 'v', '>'],
  ];

  @override
  List<String> parseInput() {
    final file = File('input/aoc21.txt');
    return file.readAsStringSync().split('\n');
  }

  // Recusive method
  List<String> getPath(List<List<String>> grid, String from, String to, List<String> history) {
    if (from == to) {
      // End of path, return A to validate
      return ['A'];
    }
    final yFrom = grid.indexWhere((list) => list.contains(from));
    final xFrom = grid[yFrom].indexWhere((letter) => letter == from);

    final path = <String>[];
    for (final dir in Directions.values) {
      final xTo = xFrom + dir.x;
      final yTo = yFrom + dir.y;

      if (_isInRange(yTo, grid, xTo)) {
        final nextChar = grid[yTo][xTo];
        if (nextChar != '_' && !history.contains(nextChar)) {
          path.addAll(
            getPath(grid, nextChar, to, [...history, from])
                .map((result) => dir.symbol + result),
          );
        }
      }
    }

    return path;
  }

  bool _isInRange(int yTo, List<List<String>> grid, int xTo) {
    return yTo >= 0 &&
        yTo < grid.length &&
        xTo >= 0 &&
        xTo < grid[yTo].length;
  }

  final Map<Step, int> cache = {};

  @override
  int solvePart1() {
    final input = parseInput();

    const numGridVals = '7894561230A';
    const dirGridVals = '^A<v>';

    final numPaths = <Pair<String, String>, List<String>>{};
    for (final numFrom in numGridVals.split('')) {
      for (final numTo in numGridVals.split('')) {
        numPaths.putIfAbsent(Pair(numFrom, numTo), () => getPath(_numGrid, numFrom, numTo, []));
      }
    }

    final dirPaths = <Pair<String, String>, List<String>>{};
    for (final dirFrom in dirGridVals.split('')) {
      for (final dirTo in dirGridVals.split('')) {
        dirPaths.putIfAbsent(Pair(dirFrom, dirTo), () => getPath(_dirGrid, dirFrom, dirTo, []));
      }
    }

    var sum = 0;
    for (final code in input) {
      var countCode = 0;
      for (var i = 0; i < code.length; i++) {
        final from = i == 0 ? 'A' : code[i - 1];
        countCode += countSteps(numPaths, dirPaths, Step(from, code[i], 3), isFirst: true);
      }
      sum += countCode * int.parse(code.substring(0, code.length - 1));
    }

    return sum;
  }

  int countSteps(Map<Pair<String, String>, List<String>> numEntries, Map<Pair<String, String>, List<String>> dirEntries, Step step, {bool isFirst = false}) {
    final entries = isFirst ? numEntries : dirEntries;
    if (cache.containsKey(step)) {
      return cache[step]!;
    }

    if (step.depth == 0) {
      // Latest depth
      return 1;
    }

    var smallestCount = maxVal;
    for (final entry in entries[Pair(step.from, step.to)]!) {
      var value = 0;
      for (var i = 0; i < entry.length; i++) {
        final from = i == 0 ? 'A' : entry[i - 1];
        value += countSteps(numEntries, dirEntries, Step(from, entry[i], step.depth - 1));
      }

      if (value < smallestCount) {
        smallestCount = value;
      }
    }

    cache.putIfAbsent(step, () => smallestCount);
    return smallestCount;
  }

  @override
  int solvePart2() {
    final input = parseInput();

    const numGridVals = '7894561230A';
    const dirGridVals = '^A<v>';

    final numPaths = <Pair<String, String>, List<String>>{};
    for (final numFrom in numGridVals.split('')) {
      for (final numTo in numGridVals.split('')) {
        numPaths.putIfAbsent(Pair(numFrom, numTo), () => getPath(_numGrid, numFrom, numTo, []));
      }
    }

    final dirPaths = <Pair<String, String>, List<String>>{};
    for (final dirFrom in dirGridVals.split('')) {
      for (final dirTo in dirGridVals.split('')) {
        dirPaths.putIfAbsent(Pair(dirFrom, dirTo), () => getPath(_dirGrid, dirFrom, dirTo, []));
      }
    }

    var sum = 0;
    for (final code in input) {
      var countCode = 0;
      for (var i = 0; i < code.length; i++) {
        final from = i == 0 ? 'A' : code[i - 1];
        countCode += countSteps(numPaths, dirPaths, Step(from, code[i], 26), isFirst: true);
      }
      sum += countCode * int.parse(code.substring(0, code.length - 1));
    }

    return sum;
  }
}

