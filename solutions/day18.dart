import 'dart:io';

import '../tool/generic_day.dart';
import '../utils/pair.dart';

class Steps {
  final Pair<int, int> currentPos;
  final Set<Pair<int, int>> history;

  Steps(this.currentPos, this.history);
}

class Day18 extends GenericDay {
  Day18() : super(18);

  @override
  List<Pair<int, int>> parseInput() {
    final file = File('input/aoc18.txt');
    final content = file.readAsStringSync();

    final array = <Pair<int, int>>[];
    final lines = content.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final parts = line.split(',');
      final x = int.parse(parts[0]);
      final y = int.parse(parts[1]);
      array.add(Pair(x, y));
    }

    return array;
  }

  bool isValidPos(Pair<int, int> pos, int mapSize) {
    return !(pos.second < 0 || pos.second > mapSize || pos.first < 0 || pos.first > mapSize);
  }

  Set<Pair<int, int>> getPath(Pair<int, int> start, Pair<int, int> end, int mapSize, Set<Pair<int, int>> blacklistedPos) {
    final visited = <Pair<int, int>>{};
    final queue = [Steps(start, {})];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      if (current.currentPos == end) {
        return current.history;
      }

      final neighbors = [
        Pair(current.currentPos.first + 1, current.currentPos.second),
        Pair(current.currentPos.first - 1, current.currentPos.second),
        Pair(current.currentPos.first, current.currentPos.second + 1),
        Pair(current.currentPos.first, current.currentPos.second - 1),
      ];

      for (var i = 0; i < neighbors.length; i++) {
        final neighbor = neighbors[i];
        if (isValidPos(neighbor, mapSize) && !blacklistedPos.contains(neighbor) && !visited.contains(neighbor)) {
          final history = Set<Pair<int, int>>.from(current.history)..add(neighbor);
          queue.add(Steps(neighbor, history));
          visited.add(neighbor);
        }
      }
    }

    return {};
  }

  @override
  int solvePart1() {
    final input = parseInput();
    const mapSize = 70;
    const bytesCount = 1024;
    final blacklistedPos = <Pair<int, int>>{};

    for (var i = 0; i < bytesCount; i++) {
      blacklistedPos.add(input[i]);
    }

    return getPath(Pair(0, 0), Pair(mapSize, mapSize), mapSize, blacklistedPos).length;
  }

  @override
  int solvePart2() {
    final input = parseInput();
    const mapSize = 70;
    const bytesCount = 1024;
    final blacklistedPos = <Pair<int, int>>{};

    for (var i = 0; i < bytesCount; i++) {
      blacklistedPos.add(input[i]);
    }

    var candidateIndex = 0;
    for (var i = bytesCount; i < input.length; i++) {
      candidateIndex = i;
      print('Checking $i');
      blacklistedPos.add(input[i]);

      final path = getPath(Pair(0, 0), Pair(mapSize, mapSize), mapSize, blacklistedPos).length;
      if (path == 0) {
        candidateIndex = i;
        break;
      }
    }

    print('Solution is ${input[candidateIndex]}');
    return candidateIndex;
  }
}
