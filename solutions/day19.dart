import 'dart:io';

import '../utils/index.dart';
import 'day07.dart';

class Day19 extends GenericDay {
  Day19() : super(19);

  @override
  Pair<List<String>, List<String>> parseInput() {
    final file = File('input/aoc19.txt');
    final content = file.readAsStringSync();

    final inputs = content.split('\n\n');
    final listColors = inputs[0].split(', ');
    final listGoals = inputs[1].split('\n');

    return Pair(listColors, listGoals);
  }
  
  bool canBeMerged(String goal, List<String> lettersToMerge) {
    if (goal.isEmpty) return true;

    var found = false;
    for (final letter in lettersToMerge) {
      if (goal.startsWith(letter)) {
        found = found || canBeMerged(goal.substring(letter.length), lettersToMerge);
      }
    }

    return found;
  }

  List<String> filterCandidates(String goal, List<String> candidates) {
    return candidates.where((e) => goal.contains(e)).toList();
  }

  @override
  int solvePart1() {
    final input = parseInput();
    final listColors = input.first..sort((a, b) => b.length.compareTo(a.length));
    final listGoals = input.second;

    var validGoals = 0;

    for (final goal in listGoals) {
      final goalCandidates = filterCandidates(goal, listColors);
      if(canBeMerged(goal, goalCandidates)) {
        validGoals++;
      }
    }

    // 200 is too low
    // 249 is too high
    return validGoals;
  }

  @override
  int solvePart2() {
    final input = parseInput();
    final listColors = input.first..sort((a, b) => b.length.compareTo(a.length));
    final listGoals = input.second;

    return listGoals.map((goal){
      return countPossibilities(goal, listColors);
    }).reduce((value, element) => value + element);
  }

  // For memoization
  final cache = <String, int>{};

  int countPossibilities(String goal, List<String> candidates) {
    if (goal.isEmpty) return 1;
    if (cache.containsKey(goal)) return cache[goal]!;

    var count = 0;
    for (final candidate in candidates) {
      if (goal.startsWith(candidate)) {
        count += countPossibilities(goal.substring(candidate.length), candidates);
      }
    }

    cache[goal] = count;
    return count;
  }
}


extension ListStringExt on List<String> {
  int get countNotEmpty => where((e) => e == '').length;
}

