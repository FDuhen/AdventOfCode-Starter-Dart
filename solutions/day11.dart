import 'dart:io';

import 'package:memoized/memoized.dart';

import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  List<int> parseInput() {
    final file = File('input/aoc11.txt');
    try {
      final content = file.readAsStringSync();
      return content.split(' ').map(int.parse).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  int blinkNumber(
    int number,
    int currentOccurrence,
    Map<int, Map<int, int>> memoized,
    int maxOccurrences,
  ) {
    if (currentOccurrence > maxOccurrences) {
      return 0;
    }

    memoized.putIfAbsent(number, () => {});

    if (memoized[number]!.containsKey(currentOccurrence)) {
      return memoized[number]![currentOccurrence]!;
    }

    // 0 -> 1
    if (number == 0) {
      final result = blinkNumber(1, currentOccurrence + 1, memoized, maxOccurrences);
      memoized[number]![currentOccurrence] = result;
      return result;
    }

    // 1 -> 2024
    if (number == 1) {
      final result = blinkNumber(2024, currentOccurrence + 1, memoized, maxOccurrences);
      memoized[number]![currentOccurrence] = result;
      return result;
    }

    final numStr = number.toString();
    final len = numStr.length;

    // Even length number -> split in half
    if (len.isEven) {
      final first = int.parse(numStr.substring(0, len ~/ 2));
      final second = int.parse(numStr.substring(len ~/ 2));
      // Add 1 because we add a new number to the list of numbers
      final result = 1 +
          blinkNumber(first, currentOccurrence + 1, memoized, maxOccurrences) +
          blinkNumber(second, currentOccurrence + 1, memoized, maxOccurrences);
      memoized[number]![currentOccurrence] = result;
      return result;
    } else {
      // Odd length number -> multiply by 2024
      final result = blinkNumber(number * 2024, currentOccurrence + 1, memoized, maxOccurrences);
      memoized[number]![currentOccurrence] = result;
      return result;
    }
  }

  @override
  int solvePart1() {
    final numbers = parseInput();
    final map = <int, Map<int, int>>{};
    var response = 0;
    const stepLimit = 25;

    for (var i = 0; i < numbers.length; i++) {
      response += blinkNumber(numbers[i], 1, map, stepLimit);
    }

    return response + numbers.length;
  }

  @override
  int solvePart2() {
    final numbers = parseInput();
    final map = <int, Map<int, int>>{};
    var response = 0;
    const stepLimit = 75;

    for (var i = 0; i < numbers.length; i++) {
      response += blinkNumber(numbers[i], 1, map, stepLimit);
    }

    return response + numbers.length;
  }
}

extension Num on num {
  int get length => toString().length;
}
