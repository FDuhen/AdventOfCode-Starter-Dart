import 'dart:io';

import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  Map<String, List<({int y, int x})>> parseInput() {
    try {
      final content = _getFileContent();
      final antennas = <String, List<({int y, int x})>>{};

      final lines = content.split('\n');
      for (var i = 0; i < lines.length; i++) {
        for (var j = 0; j < lines[i].length; j++) {
          final name = lines[i][j];
          // Skip empty spaces
          if (name == '.') continue;

          // Init the list if it doesn't exist
          if (!antennas.containsKey(name)) {
            antennas[name] = [];
          }

          // Add an antena to the map wit has a key the character name
          antennas[name]!.add((y: i, x: j));
        }
      }
      return antennas;
    } catch (e) {
      return {};
    }
  }

  @override
  int solvePart1() {
    final content = _getFileContent();
    final lines = content.split('\n');

    final antennas = parseInput();
    final antinodes = <({int y, int x})>{};

    for (final antennaList in antennas.values) {
      for (var baseIndex = 0; baseIndex < antennaList.length; baseIndex++) {
        for (var matchingIndex = 0;
            matchingIndex < antennaList.length;
            matchingIndex++) {
          if (matchingIndex == baseIndex) continue;

          // Calculate the position diff of the antinode
          final diffY = antennaList[baseIndex].y - antennaList[matchingIndex].y;
          final diffX = antennaList[baseIndex].x - antennaList[matchingIndex].x;

          // Add the antinode position to the base antenna position
          antinodes.add(
            (
              y: antennaList[baseIndex].y + diffY,
              x: antennaList[baseIndex].x + diffX
            ),
          );
        }
      }
    }

    // Exclue the out of bounds antinodes
    final validPositions = antinodes.where(
      (element) =>
          element.y >= 0 &&
          element.y < lines.length &&
          element.x >= 0 &&
          element.x < lines.first.length,
    );

    print(validPositions);
    return validPositions.length;
  }

  String _getFileContent() {
    final file = File('input/aoc08.txt');
    final content = file.readAsStringSync();
    return content;
  }

  @override
  int solvePart2() {
    final content = _getFileContent();
    final lines = content.split('\n');

    final antennas = parseInput();
    final antinodes = <({int y, int x})>{};

    for (final antennaList in antennas.values) {
      for (var baseIndex = 0; baseIndex < antennaList.length; baseIndex++) {
        for (var matchingIndex = 0;
            matchingIndex < antennaList.length;
            matchingIndex++) {
          if (matchingIndex == baseIndex) continue;

          // Calculate the position diff of the antinode
          final diffY = antennaList[baseIndex].y - antennaList[matchingIndex].y;
          final diffX = antennaList[baseIndex].x - antennaList[matchingIndex].x;

          // Define the antinode position projection
          var projY = antennaList[baseIndex].y;
          var projX = antennaList[baseIndex].x;

          // Replicate the antinode position to the base antenna position
          // Until it's out of bounds
          while (projY >= 0 &&
              projY < lines.length &&
              projX >= 0 &&
              projX < lines.first.length) {
            antinodes.add((y: projY, x: projX));

            projY = projY + diffY;
            projX = projX + diffX;
          }
        }
      }
    }

    // Exclude the out of bounds antinodes
    final validPositions = antinodes.where(
      (element) =>
          element.y >= 0 &&
          element.y < lines.length &&
          element.x >= 0 &&
          element.x < lines.first.length,
    );

    print(validPositions);
    return validPositions.length;
  }
}
