import 'dart:io';

import '../utils/index.dart';
import '../utils/utils.dart';

class Zone {
  Zone(this.size, this.perimeter);

  final int size;
  final int perimeter;
}

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  List<List<String>> parseInput() {
    final file = File('input/aoc12.txt');
    final content = file.readAsStringSync();
    return stringToStringMap(content);
  }

  // Iterer sur chaque element de la map
  // On commence à i;j = 0;0
  // On prends la lettre actuelle, on incrémente son périmètre + son area
  // On regarde si on peut aller à gauche, en bas, à droite, en haut
  // Si c'est le cas, on passe à i;j = i+1;j ou i=0;j+1 si on arrive au bout de la ligne
  // On vérifie si la lettre à i;j est la meme que la lettre actuelle; si c'est le cas on incrémente juste le périmètre de N (N étant le nombre de lettres autour de la lettre actuelle)
  // On continue jusqu'à ce qu'on ne puisse plus aller nulle part avec la lettre actuelle
  // Quand c'est fait, on passe à la lettre suivante et on recommence l'algo ci-dessus

  // CHeck if the Pos is in the array limits
  bool inBounds(int x, int y, List<List<String>> map) {
    return x >= 0 && y >= 0 && y < map.length && x < map[y].length;
  }

  // List of methods to check if the current letter has a neighbour and is in bounds
  bool hasLeftNeighbour(int x, int y, String letter, List<List<String>> map) {
    return inBounds(x - 1, y, map) && map[y][x - 1] == letter;
  }

  bool hasRightNeighbour(int x, int y, String letter, List<List<String>> map) {
    return inBounds(x + 1, y, map) && map[y][x + 1] == letter;
  }

  bool hasTopNeighbour(int x, int y, String letter, List<List<String>> map) {
    return inBounds(x, y - 1, map) && map[y - 1][x] == letter;
  }

  bool hasBottomNeighbour(int x, int y, String letter, List<List<String>> map) {
    return inBounds(x, y + 1, map) && map[y + 1][x] == letter;
  }

  // Lisf of methods to check if the current letter has a neighbour with
  // The same letter, and which is not visited yet
  bool hasUnvisitedLeftNeighbour(
    int x,
    int y,
    String letter,
    List<List<String>> map,
    List<List<bool>> visited,
  ) {
    return hasLeftNeighbour(x, y, letter, map) && !visited[y][x - 1];
  }

  bool hasUnvisitedRightNeighbour(
    int x,
    int y,
    String letter,
    List<List<String>> map,
    List<List<bool>> visited,
  ) {
    return hasRightNeighbour(x, y, letter, map) && !visited[y][x + 1];
  }

  bool hasUnvisitedTopNeighbour(
    int x,
    int y,
    String letter,
    List<List<String>> map,
    List<List<bool>> visited,
  ) {
    return hasTopNeighbour(x, y, letter, map) && !visited[y - 1][x];
  }

  bool hasUnvisitedBottomNeighbour(
    int x,
    int y,
    String letter,
    List<List<String>> map,
    List<List<bool>> visited,
  ) {
    return hasBottomNeighbour(x, y, letter, map) && !visited[y + 1][x];
  }

  // Check if the current letter has at least one unvisited neighbour in
  // One of the four directions
  bool hasUnvisitedNeighbours(
    int x,
    int y,
    String letter,
    List<List<String>> map,
    List<List<bool>> visited,
  ) {
    return hasUnvisitedLeftNeighbour(x, y, letter, map, visited) ||
        hasUnvisitedRightNeighbour(x, y, letter, map, visited) ||
        hasUnvisitedTopNeighbour(x, y, letter, map, visited) ||
        hasUnvisitedBottomNeighbour(x, y, letter, map, visited);
  }

  // Get the perimeter of the current letter at pos x;y
  // Depends on the number of neighbours of another letter
  int getPerimeter(int x, int y, String letter, List<List<String>> map) {
    var perimeter = 0;
    if (!hasLeftNeighbour(x, y, letter, map)) perimeter++;
    if (!hasRightNeighbour(x, y, letter, map)) perimeter++;
    if (!hasTopNeighbour(x, y, letter, map)) perimeter++;
    if (!hasBottomNeighbour(x, y, letter, map)) perimeter++;
    return perimeter;
  }

  Set<Pos> getAreaForLetter(
    int x,
    int y,
    String letter,
    List<List<String>> map,
    List<List<bool>> visited,
  ) {
    final result = <Pos>{};
    visited[y][x] = true;
    result.add(Pos(x, y));

    if (!hasUnvisitedNeighbours(x, y, letter, map, visited)) {
      return result;
    } else {
      if (hasUnvisitedLeftNeighbour(x, y, letter, map, visited)) {
        result.addAll(getAreaForLetter(x - 1, y, letter, map, visited));
      }
      if (hasUnvisitedRightNeighbour(x, y, letter, map, visited)) {
        result.addAll(getAreaForLetter(x + 1, y, letter, map, visited));
      }
      if (hasUnvisitedTopNeighbour(x, y, letter, map, visited)) {
        result.addAll(getAreaForLetter(x, y - 1, letter, map, visited));
      }
      if (hasUnvisitedBottomNeighbour(x, y, letter, map, visited)) {
        result.addAll(getAreaForLetter(x, y + 1, letter, map, visited));
      }
      return result;
    }
  }

  List<Zone> addPerimeterToPrice(
    int x,
    int y,
    String letter,
    List<List<String>> map,
    List<List<bool>> visited,
    int size,
    int perimeter,
  ) {
    final result = <Zone>[];
    visited[y][x] = true;
    perimeter += getPerimeter(x, y, letter, map);

    if (!hasUnvisitedNeighbours(x, y, letter, map, visited)) {
      result.add(Zone(size, perimeter));
      return result;
    } else {
      var visitedNeighbour = false;
      if (hasUnvisitedLeftNeighbour(x, y, letter, map, visited)) {
        result.addAll(
          addPerimeterToPrice(
              x - 1,
              y,
              letter,
              map,
              visited,
              visitedNeighbour ? 1 : size + 1,
              visitedNeighbour ? 0 : perimeter),
        );
        visitedNeighbour = true;
      }
      if (hasUnvisitedRightNeighbour(x, y, letter, map, visited)) {
        result.addAll(
          addPerimeterToPrice(
              x + 1,
              y,
              letter,
              map,
              visited,
              visitedNeighbour ? 1 : size + 1,
              visitedNeighbour ? 0 : perimeter),
        );
        visitedNeighbour = true;
      }
      if (hasUnvisitedTopNeighbour(x, y, letter, map, visited)) {
        result.addAll(
          addPerimeterToPrice(
              x,
              y - 1,
              letter,
              map,
              visited,
              visitedNeighbour ? 1 : size + 1,
              visitedNeighbour ? 0 : perimeter),
        );
        visitedNeighbour = true;
      }
      if (hasUnvisitedBottomNeighbour(x, y, letter, map, visited)) {
        result.addAll(
          addPerimeterToPrice(
              x,
              y + 1,
              letter,
              map,
              visited,
              visitedNeighbour ? 1 : size + 1,
              visitedNeighbour ? 0 : perimeter),
        );
        visitedNeighbour = true;
      }
      return result;
    }
  }

  int calculatePriceWithPerimeter(List<List<String>> map) {
    final visited = List.generate(
        map.length, (_) => List.generate(map[0].length, (_) => false));
    var totalPrice = 0;

    for (var y = 0; y < map.length; y++) {
      for (var x = 0; x < map[0].length; x++) {
        if (!visited[y][x]) {
          print(map[y][x]);
          final result =
              addPerimeterToPrice(x, y, map[y][x], map, visited, 1, 0);
          totalPrice += result.fold(0, (sum, r) => sum + r.size) *
              result.fold(0, (sum, r) => sum + r.perimeter);
        }
      }
    }
    return totalPrice;
  }

  @override
  int solvePart1() {
    final inputData = parseInput();

    return calculatePriceWithPerimeter(inputData);
  }


  bool hasTopLeftNeighbour(Pos p, Set<Pos> Poss) {
    return Poss.contains(Pos(p.x - 1, p.y - 1));
  }

  bool hasTopRightNeighbour(Pos p, Set<Pos> Poss) {
    return Poss.contains(Pos(p.x + 1, p.y - 1));
  }

  bool hasBottomRightNeighbour(Pos p, Set<Pos> Poss) {
    return Poss.contains(Pos(p.x + 1, p.y + 1));
  }

  bool hasBottomLeftNeighbour(Pos p, Set<Pos> Poss) {
    return Poss.contains(Pos(p.x - 1, p.y + 1));
  }

  bool hasLeftNeighbourPos(Pos p, Set<Pos> Poss) {
    return Poss.contains(Pos(p.x - 1, p.y));
  }

  bool hasRightNeighbourPos(Pos p, Set<Pos> Poss) {
    return Poss.contains(Pos(p.x + 1, p.y));
  }

  bool hasTopNeighbourPos(Pos p, Set<Pos> Poss) {
    return Poss.contains(Pos(p.x, p.y - 1));
  }

  bool hasBottomNeighbourPos(Pos p, Set<Pos> Poss) {
    return Poss.contains(Pos(p.x, p.y + 1));
  }

  int countNumberOfSides(Set<Pos> Poss) {
    var total = 0;
    for (final Pos in Poss) {
      var corners = 0;
      if (!hasLeftNeighbourPos(Pos, Poss) && !hasTopNeighbourPos(Pos, Poss) ||
          (!hasTopLeftNeighbour(Pos, Poss) && hasLeftNeighbourPos(Pos, Poss) &&
              hasTopNeighbourPos(Pos, Poss))) {
        corners++;
      }
      if (!hasRightNeighbourPos(Pos, Poss) && !hasTopNeighbourPos(Pos, Poss) ||
          (!hasTopRightNeighbour(Pos, Poss) && hasRightNeighbourPos(Pos, Poss) &&
              hasTopNeighbourPos(Pos, Poss))) {
        corners++;
      }
      if (!hasRightNeighbourPos(Pos, Poss) && !hasBottomNeighbourPos(Pos, Poss) ||
          (!hasBottomRightNeighbour(Pos, Poss) && hasRightNeighbourPos(Pos, Poss) &&
              hasBottomNeighbourPos(Pos, Poss))) {
        corners++;
      }
      if (!hasLeftNeighbourPos(Pos, Poss) && !hasBottomNeighbourPos(Pos, Poss) ||
          (!hasBottomLeftNeighbour(Pos, Poss) && hasLeftNeighbourPos(Pos, Poss) &&
              hasBottomNeighbourPos(Pos, Poss))) {
        corners++;
      }
      total += corners;
    }
    return total;
  }

  @override
  int solvePart2() {
    final inputData = parseInput();

    // Almost same login as 1 but we need to count the number of sides
    // So to do so, I'm  fetching the Area of each letter and then I'm counting the number of Corners for each area to get the total number of sides
    final visited = List.generate(inputData.length, (_) => List.generate(inputData[0].length, (_) => false));
    var totalPrice = 0;

    for (var y = 0; y < inputData.length; y++) {
      for (var x = 0; x < inputData[0].length; x++) {
        if (!visited[y][x]) {
          final area = getAreaForLetter(x, y, inputData[y][x], inputData, visited);
          totalPrice += area.length * countNumberOfSides(area);
        }
      }
    }
    return totalPrice;
  }
}
