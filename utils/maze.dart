
import 'position.dart';
import 'utils.dart';

class Maze {
  static const List<List<int>> directions = [
    [0, 1], // Top
    [1, 0], // Right
    [0, -1], // Bottom
    [-1, 0], // Left
  ];

  late List<List<String>> grid;
  late int width;
  late int height;

  Maze(String fileInput) {
    final input = stringToStringMap(fileInput);
    grid = List<List<String>>.generate(input[0].length, (y) => List.generate(input.length, (x) => input[x][y],));
    width = grid[0].length;
    height = grid.length;
  }

  // Returns the top / left / bottom / right neighbors of a position
  // Handles out of bounds positions
  List<Pos> getNeighborsPos(Pos pos) {
    final neighbors = <Pos>[];
    for (final dir in directions) {
      final newPos = Pos(pos.x + dir[0], pos.y + dir[1]);
      if (newPos.x >= 0 && newPos.x < width && newPos.y >= 0 && newPos.y < height) {
        neighbors.add(newPos);
      }
    }
    return neighbors;
  }

  Pos getPosOf( String letter) {
    for (var x = 0; x < grid.length; x++) {
      for (var y = 0; y < grid[x].length; y++) {
        if (grid[x][y] == letter) {
          return Pos(x, y);
        }
      }
    }
    return const Pos(-1, -1);
  }
}
