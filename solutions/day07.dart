import 'dart:io';
import 'dart:math' as math;

import '../utils/index.dart';

class Pair<F, S> {
  Pair(this.first, this.second);

  final F first;
  final S second;
}

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  List<Pair<int, List<int>>> parseInput() {
    final input = File('input/aoc07.txt');

    return input.readAsLinesSync().map((line) {
      final numbers = line.extractNumbers();
      return Pair(numbers.first, numbers.sublist(1));
    }).toList();
  }

  @override
  int solvePart1() {
    // Iterate through all the entries and combine them
    return parseInput().fold<int>(0, (previousSUm, entry) {
      final sum = entry.first;
      final numbers = entry.second;

      // Iterate though all the possible combinations (2^(n-1))
      final isGood = List.generate(1 << numbers.length - 1, (i) {
        var result = numbers.first;
        for (var j = 1; j <= numbers.length - 1; j++) {
          // Check the j-1 bit of i
          if ((i >> (j - 1)) & 1 == 0) {
            // If the bit is 0, add the current number to the result
            result += numbers[j];
          } else {
            // If the bit is 1, multiply the current number with the result
            result *= numbers[j];
          }
          // If the result exceeds the target sum, abort mission
          if (result > sum) break;
        }
        return result == sum;
      }).any((isGood) => isGood);

      return previousSUm + (isGood ? sum : 0);
    });
  }

  @override
  int solvePart2() {
    return parseInput().fold<int>(0, (previousSum, entry) {
      final sum = entry.first;
      final numbers = entry.second;

      final isGood = List.generate(
        3.pow(numbers.length - 1),
        (i) {
          var result = numbers.first;
          var c = i;
          for (var j = 1; j <= numbers.length - 1; j++) {
            switch (c % 3) {
              case 0:
                result += numbers[j];
              case 1:
                result *= numbers[j];
              case 2:
                result = concat(result, numbers[j]);
            }
            c ~/= 3;
            if (result > sum) break;
          }
          return result == sum;
        },
      ).any((isGood) => isGood);

      return previousSum + (isGood ? sum : 0);
    });
  }
}

// Thank you GPT for this, it improved the performance of the solution by a lot
int concat(int a, int b) {
  if (b < 10) return a * 10 + b;
  if (b < 100) return a * 100 + b;
  if (b < 1000) return a * 1000 + b;
  if (b < 10000) return a * 10000 + b;

  return (10.pow(b.toString().length) * a) + b;
}

extension StringExtensions on String {
  List<int> extractNumbers() {
    return split(RegExp(r'\D+'))
        .where((element) => element.isNotEmpty)
        .map(int.parse)
        .toList();
  }
}

extension IntExtensions on int {
  // Returns the power of the current number
  int pow(int power) {
    return math.pow(this, power).toInt();
  }
}
