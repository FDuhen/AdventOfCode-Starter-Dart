import 'dart:io';

import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  String parseInput() {
    final file = File('input/aoc03.txt');
    try {
      final content = file.readAsStringSync();
      return content;
    } catch (e) {
      return '';
    }
  }

  @override
  int solvePart1() {
    return _matchAndCount(parseInput());
  }

  int _matchAndCount(String entry) {
    final regex = RegExp(r'mul\((\d{1,3}),(\d{1,3})\)');
    var result = 0;
    regex
        .allMatches(entry)
        .map((m) => int.parse(m.group(1)!) * int.parse(m.group(2)!))
        .forEach(
          (singleVal) => result += singleVal,
    );
    return result;
  }

  @override
  int solvePart2() {
    final regex = RegExp(r"(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))");
    final matches = regex.allMatches(parseInput()).map((m) => m.group(0)).toList();

    var result = 0;
    var skip = false;
    for (final entry in matches) {
      if (entry == 'do()') {
        skip = false;
      } else if (entry == "don't()") {
        skip = true;
      } else if (!skip) {
        final count = _matchAndCount(entry!);
        result += count;
      } else {
        print('Skipped $entry');
      }
    }

    return result;
  }
}
