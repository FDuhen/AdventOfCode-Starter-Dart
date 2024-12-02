import 'dart:io';

import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  String parseInput() {
    final file = File('input/aoc02.txt');
    try {
      final content = file.readAsStringSync();
      return content;
    } catch (e) {
      return '';
    }
  }

  bool _checkSafety(List<int> report) {
    // Check that every entry has a diff between 1 and 3
    final windowCondition = report.asMap().entries.every((entry) {
      if (entry.key == report.length - 1) return true;
      final a = entry.value;
      final b = report[entry.key + 1];
      return (b - a).abs() >= 1 && (b - a).abs() <= 3;
    });

    // Check if the list is already sorted
    final sorted = List<int>.from(report)..sort();
    final sortedCondition = report.toString() == sorted.toString() ||
        report.toString() == sorted.reversed.toList().toString();

    return windowCondition && sortedCondition;
  }

  int _countSafeFirst(List<List<int>> allInts) {
    return allInts.where(_checkSafety).length;
  }

  int _countSafeSecond(List<List<int>> allInts) {
    return allInts.where((list) {
      // Check if the list is Safe and returns it if it is
      // If the list is not safe, remove each item one by one to check if
      // One of the sublists is safe
      return _checkSafety(list) ||
          Iterable<bool>.generate(list.length).any((index) {
            final idx = index as int;
            final modifiedList = <int>[
              ...list.take(idx),
              ...list.skip(idx + 1),
            ];
            return _checkSafety(modifiedList);
          });
    }).length;
  }

  @override
  int solvePart1() {
    final content = parseInput();
    final lines = content.split('\n')..removeLast();
    final arrays = lines.map((e) => e.split(' '),).toList();
    final intArrays = arrays.map((e) => e.map(int.parse).toList()).toList();

    return _countSafeFirst(intArrays);
  }

  @override
  int solvePart2() {
    final content = parseInput();
    final lines = content.split('\n')..removeLast();
    final arrays = lines.map((e) => e.split(' '),).toList();
    final intArrays = arrays.map((e) => e.map(int.parse).toList()).toList();

    return _countSafeSecond(intArrays);
  }
}

