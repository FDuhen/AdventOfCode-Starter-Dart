import 'dart:io';

import '../utils/index.dart';
import '../utils/pair.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  List<int> parseInput() {
    final file = File('input/aoc09.txt');
    try {
      final content = file.readAsStringSync();
      return content.split('').map(int.parse).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  int solvePart1() {
    final initialRow = parseInput();
    final transformedList = <String>[];

    // Store the indexes of the dots
    final dotPositions = <int>[];
    var numberOccurence = 0;

    for (var i = 0; i < initialRow.length; i++) {
      final currentNumber = initialRow[i];
      if (currentNumber == 0) continue;

      for (var j = 0; j < currentNumber; j++) {
        if ((i%2).isEven) {
          transformedList.add('$numberOccurence');
        } else {
          transformedList.add('.');
          dotPositions.add(transformedList.length - 1);
        }
      }

      if ((i%2).isEven) {
        numberOccurence++;
      }
    }

    // print(transformedList);

    for (var i = transformedList.length - 1; i >= 0; i--) {
      // If the position of the first dot to replace is above the current index
      // It means we are done
      if (dotPositions.first >= i) {
        break;
      }

      if (transformedList[i] != '.') {
        transformedList[dotPositions.first] = transformedList[i];
        dotPositions.removeAt(0);
        transformedList[i] = '.';
      }
    }

    var result = 0;
    for (var i = 0; i < transformedList.length; i++) {
      if (transformedList[i] == '.') {
        return result;
      }

      result += int.parse(transformedList[i]) * i;
    }

    return result;
  }

  @override
  int solvePart2() {
    final initialRow = parseInput();
    // Pair of index and second
    // second will be N times the same number or N times a dot
    final transformedList = <Pair<String, int>>[];

    for (var i = 0; i < initialRow.length; i++) {
      final currentNumber = initialRow[i];
      if (currentNumber == 0) continue;

      if ((i % 2).isEven) {
        transformedList.add(
          Pair(
            (i~/2).toString(),
            currentNumber,
            ),
        );
      } else {
        transformedList.add(
          Pair(
            '.',
      currentNumber,
          ),
        );
      }
    }

    // Find the maximum id to move
    var idToMove = transformedList
        .where((entry) => entry.first != '.')
        .map((entry) => int.parse(entry.first))
        .reduce((a, b) => a > b ? a : b);

    while (idToMove >= 1) {
      final blockToMove = transformedList.indexWhere((entry) => entry.first == idToMove.toString());
      final spaceToReplace = transformedList.indexWhere((entry) => entry.first == '.' && entry.second >= transformedList[blockToMove].second);

      if (spaceToReplace != -1 && blockToMove > spaceToReplace) {
        if (transformedList[blockToMove].second < transformedList[spaceToReplace].second) {
          final diff = transformedList[spaceToReplace].second - transformedList[blockToMove].second;
          transformedList[blockToMove] = Pair('.', transformedList[blockToMove].second);
          transformedList[spaceToReplace] = Pair(idToMove.toString(), transformedList[spaceToReplace].second - diff);
          transformedList.insert(spaceToReplace + 1, Pair('.', diff));
        } else if (transformedList[blockToMove].second == transformedList[spaceToReplace].second) {
          transformedList.swap(blockToMove, spaceToReplace);
        }
      }
      idToMove--;
    }

    final flattenedList = transformedList
        .expand((block) => List<String>.filled(block.second, block.first))
        .toList();

    var result = 0;
    for (var i = 0; i < flattenedList.length; i++) {
      print(flattenedList[i]);
      if (flattenedList[i] == '.') {
        continue;
      }

      result += int.parse(flattenedList[i]) * i;
    }

    return result;
  }

}
