import 'dart:io';

import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  String parseInput() {
    final file = File('input/aoc01.txt');
    try {
      final content = file.readAsStringSync();
      return content;
    } catch (e) {
      return '';
    }
  }

  @override
  int solvePart1() {
    final content = parseInput();
    final lines = content.split('\n')..removeLast();
    final pairs = lines.map((e) => e.split('   '),).toList();

    final firstColumn = pairs.map((e) => e[0],).toList()..sort();
    final secondColumn = pairs.map((e) => e[1],).toList()..sort();

    var diffs = 0;
    for (var i = 0; i < firstColumn.length; i++) {
      final diff = int.parse(firstColumn[i]) - int.parse(secondColumn[i]);
      diffs += diff.abs();
    }

    return diffs;
  }

  @override
  int solvePart2() {
    final content = parseInput();
    final lines = content.split('\n')..removeLast();
    final pairs = lines.map((e) => e.split('   '),).toList();

    final firstColumn = pairs.map((e) => e[0],).toList()..sort();
    final secondColumn = pairs.map((e) => e[1],).toList()..sort();

    var count = 0;
    for (var i = 0; i < firstColumn.length; i++) {
      final currentLeft = int.parse(firstColumn[i]);
      final occurencesInRight = secondColumn.where((e) => int.parse(e) == currentLeft).length;
      count += occurencesInRight*currentLeft;
    }

    return count;
  }
}

