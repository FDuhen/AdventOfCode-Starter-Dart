import 'dart:io';

import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  String parseInput() {
    final file = File('input/aoc04.txt');
    try {
      final content = file.readAsStringSync();
      return content;
    } catch (e) {
      return '';
    }
  }

  List<String> splitLines(String input) {
    return input.split('\n')..removeLast();
  }

  List<String> splitColumns(String input) {
    final splitColumn = <String>[];
    final mapLines = <List<String>>[];
    final lines = input.split('\n')..removeLast();

    for (final line in lines) {
      mapLines.add(line.split(''));
    }

    // Iterate threw each item of the first map
    for (var i = 0; i < mapLines[0].length; i++) {
      final listColumn = [];
      for (var j = 0; j < mapLines.length; j++) {
        listColumn.add(mapLines[j][i]);
      }

      splitColumn.add(listColumn.join());
    }

    return splitColumn;
  }

  List<String> transformToDiagonalsFromTopLeft(List<String> input) {
    final rows = input.length;
    final cols = input[0].length;
    final maxDiagonals = rows + cols - 1;

    final diagonals = List<StringBuffer>.generate(maxDiagonals, (_) => StringBuffer());

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        diagonals[row + col].write(input[row][col]);
      }
    }

    return diagonals.map((buffer) => buffer.toString()).toList();
  }

  List<String> transformToDiagonalsFromTopRight(List<String> input) {
    final rows = input.length;
    final cols = input[0].length;
    final maxDiagonals = rows + cols - 1;

    // Initialize a list of StringBuffers for the diagonals
    final diagonals = List<StringBuffer>.generate(maxDiagonals, (_) => StringBuffer());

    // Populate the diagonals
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        // Calculate the index for reversed diagonals
        final diagonalIndex = (cols - 1 - col) + row;
        diagonals[diagonalIndex].write(input[row][col]);
      }
    }

    // Convert StringBuffer to String and return
    return diagonals.map((buffer) => buffer.toString()).toList();
  }


  @override
  int solvePart1() {
    final regex = RegExp('XMAS');
    final regexReverse = RegExp('SAMX');

    final lines = splitLines(parseInput());
    final columns = splitColumns(parseInput());
    final diagonalTopLeft = transformToDiagonalsFromTopLeft(splitLines(parseInput()));
    final diagonalTopRight = transformToDiagonalsFromTopRight(splitLines(parseInput()));

    final allArrays = [...lines, ...columns, ...diagonalTopRight, ...diagonalTopLeft];

    var count = 0;
    for (var line in allArrays) {
      count += regex.allMatches(line).length;
      count += regexReverse.allMatches(line).length;
    }


    print(count);
    return count;
  }

  @override
  int solvePart2() {
    final input = <List<String>>[];
    final lines = parseInput().split('\n')..removeLast();
    for(final line in lines) {
      input.add(line.split(''));
    }

    var count = 0;

    for (var i = 0; i < input.length; i++) {
      for (var j = 0; j < input[i].length; j++) {
        final firstDiag =
            "${i > 0 && j > 0 ? input[i - 1][j - 1] : '-'}"
            '${input[i][j]}'
            "${i + 1 < input.length && j + 1 < input[i + 1].length ? input[i + 1][j + 1] : '-'}";

        final secondDiag =
            "${i + 1 < input.length && j > 0 ? input[i + 1][j - 1] : '-'}"
            '${input[i][j]}'
            "${i > 0 && j + 1 < input[i - 1].length ? input[i - 1][j + 1] : '-'}";

        if ((firstDiag == 'SAM' || firstDiag == 'MAS') && (secondDiag == 'SAM' || secondDiag == 'MAS')) {
          count++;
        }
      }
    }

    return count;
  }
}
