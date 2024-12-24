import 'dart:io';
import 'dart:math' as math;

import '../utils/index.dart';

class Day22 extends GenericDay {
  Day22() : super(22);

  @override
  List<int> parseInput() {
    final file = File('input/aoc22.txt');
    return file.readAsStringSync().split('\n').map(int.parse).toList();
  }

  int mix(int value, int secretNumber) {
    return value ^ secretNumber;
  }

  int prune(int secretNumber) {
    return secretNumber % 16777216;
  }

  int calculateSecret(int secretNumber, int depth) {
    if (depth == 0) {
      return secretNumber;
    }

    final first = prune(mix(secretNumber * 64, secretNumber));
    final second = prune(mix(first ~/ 32, first));
    final third = prune(mix(second * 2048, second));
    return calculateSecret(third, depth - 1);
  }

  List<int> getPrices(int secretNumber, int depth) {
    if (depth == 0) {
      return [];
    }

    final first = prune(mix(secretNumber * 64, secretNumber));
    final second = prune(mix(first ~/ 32, first));
    final third = prune(mix(second * 2048, second));
    return getPrices(third, depth - 1)..add(secretNumber % 10);
  }

  @override
  int solvePart1() {
    return parseInput().fold(0, (acc, element) => acc + calculateSecret(element, 2000));
  }

  // TODO Works on test case, but not on the real input
  // IDK why...
  @override
  int solvePart2() {
    final monkeys = parseInput();
    // Have to use this dirty (int, int..) because Dart doesn't support tuples
    // And we cannot use the List<int> as a key in a map because it's not hashable
    final aggregatedPrices = <(int, int, int, int), int>{};

    for (final monkey in monkeys) {
      final listPrices = getPrices(monkey, 2001).reversed.toList();

      final prices = <(int, int, int, int), int>{};
      final changes = <int>[];

      for (var i = 0; i < listPrices.length - 1; i++) {
        changes.add(listPrices[i + 1] - listPrices[i]);
      }

      for (var i = 0; i <= changes.length - 4; i++) {
        final window = changes.sublist(i, i + 4);
        final key = (window[0], window[1], window[2], window[3]);
        prices[key] ??= listPrices[i + 4];
      }

      for (final ((int, int, int, int) change) in prices.keys) {
        aggregatedPrices[change] = (aggregatedPrices[change] ?? 0) + prices[change]!;
      }
    }


    // 2039 is wrong, too low ??? Idk why
    return aggregatedPrices.values.reduce(math.max);
  }
}

