import 'dart:io';

import '../utils/index.dart';
import '../utils/pair.dart';

enum Type { key, lock }

class KeyLock {
  final Type type;
  final Set<Pair<int, int>> positions;

  KeyLock(this.type, this.positions);

  bool overlaps(KeyLock other) {
    return positions.any((element) => other.positions.contains(element));
  }
}

class Day25 extends GenericDay {
  Day25() : super(25);

  @override
  List<KeyLock> parseInput() {
    final file = File('input/aoc25.txt');
    final data = file.readAsStringSync().split('\n\n').toList();
    final keyLocks = <KeyLock>[];

    for (final grid in data) {
      final lines = grid.split('\n');
      final type = lines.first.contains('#') ? Type.lock : Type.key;
      final positions = <Pair<int, int>>[];

      for (var i = 0; i < lines.length; i++) {
        for (var j = 0; j < lines[i].length; j++) {
          if (lines[i][j] == '#') {
            positions.add(Pair(i, j));
          }
        }
      }

      keyLocks.add(KeyLock(type, positions.toSet()));
    }

    return keyLocks;
  }

  @override
  int solvePart1() {
    final keyLocks = parseInput();

    final keys = keyLocks.where((e) => e.type == Type.key);
    final locks = keyLocks.where((e) => e.type == Type.lock);

    var count = 0;
    for (final key in keys) {
      for (final lock in locks) {
        if (!key.overlaps(lock)) {
          count++;
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
