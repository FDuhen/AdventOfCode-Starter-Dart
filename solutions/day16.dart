import 'dart:io';

import '../utils/index.dart';
import '../utils/utils.dart';
import 'dart:math' as math;

class CurrentPosition {
  final int x;
  final int y;
  final String? direction;

  CurrentPosition(this.x, this.y, this.direction);
}

class Segment {
  final List<CurrentPosition> positions;

  // Other paths when at the end of a segment
  // For a maze with a single route, no subsegments
  Map<String, CurrentPosition> positionHistory;
  final List<Segment> subSegments;
  Segment? parentSegment;
  bool isBlocked;
  bool isEnd;

  Segment(this.positions, this.subSegments, this.isBlocked, this.isEnd, this.positionHistory,
      {this.parentSegment});
}

// Crée un segment à partir d'une position
// Un segment = une suite de points sans doute ou autre possibilité
// Un segment peut avoir des sous-segments
// Un sous-segment part toujours d'une position avec plusieurs directions possibles
// Un sous-segment peut être bloqué
// Un sous-segment peut être la fin du chemin

class Day16 extends GenericDay {
  Day16() : super(16);

  static const dirTop = '^';
  static const dirLeft = '<';
  static const dirRight = '>';
  static const dirBottom = 'v';
  static const directions = [dirTop, dirRight, dirLeft, dirBottom];

  String reverseDirection(String? direction) {
    if (direction == dirTop) {
      return dirBottom;
    } else if (direction == dirBottom) {
      return dirTop;
    } else if (direction == dirLeft) {
      return dirRight;
    } else if (direction == dirRight) {
      return dirLeft;
    }
    return '';
  }

  @override
  List<List<String>> parseInput() {
    final file = File('input/aoc16.txt');
    final content = file.readAsStringSync();
    return stringToStringMap(content);
  }


  List<int> getDirectionsModifiers(String projectionDir) {
    if (projectionDir == dirTop) {
      return [-1, 0];
    } else if (projectionDir == dirBottom) {
      return [1, 0];
    } else if (projectionDir == dirLeft) {
      return [0, -1];
    } else if (projectionDir == dirRight) {
      return [0, 1];
    }
    return [];
  }


  // Return the new possible positions from the currentPos.
  // If there is only one Current Position returned, no subsegment should be created
  // Returns empty list on dead end or on loop
  List<CurrentPosition> getPossibleDirections(List<List<String>> maze, CurrentPosition currentPos, Segment currentSegment, Map<String, CurrentPosition> blacklistedPositions) {
    final possiblePositions = List<CurrentPosition>.empty(growable: true);
    final positionHistory = currentSegment.positionHistory;

    for (final direction in directions) {
      final modifiers = getDirectionsModifiers(direction);
      final x = currentPos.x + modifiers[1];
      final y = currentPos.y + modifiers[0];

      if (x < 0 || y < 0 || x >= maze[0].length || y >= maze.length) {
        continue;
      }

      final nextPos = maze[y][x];
      if (nextPos == '#') {
        continue;
      }

      final key = '$x,$y';
      // We can't go back to a previous position
      if (positionHistory.containsKey(key) || blacklistedPositions.containsKey(key)) {
        continue;
      }

      final newDirection = direction;
      final newCurrentPos = CurrentPosition(x, y, newDirection);
      possiblePositions.add(newCurrentPos);

      // Don't add the end to the history
      if (nextPos != 'E') {
        positionHistory[key] = newCurrentPos;
        currentSegment.positionHistory = positionHistory;
      }
    }

    return possiblePositions;
  }

  Pos getLetterIndex(List<List<String>> map, String letter) {
    for (var y = 0; y < map.length; y++) {
      for (var x = 0; x < map[y].length; x++) {
        if (map[y][x] == letter) {
          return Pos(x, y);
        }
      }
    }
    return const Pos(-1, -1);
  }

  List<CurrentPosition> getPathFromSegment(Segment segment) {
    final path = List<CurrentPosition>.empty(growable: true);
    var currentSegment = segment;
    while (currentSegment.parentSegment != null) {
      path.addAll(currentSegment.positions.reversed.toList());
      currentSegment = currentSegment.parentSegment!;
    }
    return path;
  }

  @override
  int solvePart1() {
    final input = parseInput();
    final maze = List<Segment>.empty(growable: true);
    final startPosition = getLetterIndex(input, 'S');
    final endPosition = getLetterIndex(input, 'E');
    final initialPos = CurrentPosition(startPosition.x, startPosition.y, null);
    final startSegment = Segment([initialPos], [], false, false,{}, parentSegment: Segment([], [], false, false, {}));
    final blacklistedPositions = <String, CurrentPosition>{};

    final toExplore = QueueList<Segment>();
    toExplore.add(startSegment);
    maze.add(startSegment);
    final segmentHistory = <String, CurrentPosition>{};
    segmentHistory['${startPosition.x},${startPosition.y}'] = initialPos;
    startSegment.positionHistory = segmentHistory;

    final correctPaths = List<List<CurrentPosition>>.empty(growable: true);

    while (toExplore.isNotEmpty) {
      final segment = toExplore.removeFirst();
      final currentPos = segment.positions.last;

      final possibleDirections = getPossibleDirections(input, currentPos, segment, blacklistedPositions);
      // Dead end, or loop
      if (possibleDirections.isEmpty) {
        // May be on the position of the end, so its a win
        if (currentPos.x == endPosition.x && currentPos.y == endPosition.y) {
          segment.isEnd = true;
        } else {
          for (final pos in segment.positions) {
            blacklistedPositions['${pos.x},${pos.y}'] = pos;
          }
          print('blocked and ${blacklistedPositions.length}');
          segment.isBlocked = true;
        }
        continue;
      }

      // One possible direction, we follow it and add it to the segment
      if (possibleDirections.length == 1) {
        if (possibleDirections.first.x == endPosition.x && possibleDirections.first.y == endPosition.y) {
          print('end found');
          segment.isEnd = true;
          correctPaths.add(getPathFromSegment(segment));
          continue;
        }
        segment.positions.add(possibleDirections.first);
        toExplore.add(segment);
        continue;
      }

      // Multiple possibilities, creating two subsegments
      for (final direction in possibleDirections) {
        if (direction.x == endPosition.x && direction.y == endPosition.y) {
          print('end found');
          segment.isEnd = true;
          continue;
        }

        // TODO position History
        final newSegment = Segment([direction], [], false, false, Map.from(segment.positionHistory), parentSegment: segment);
        segment.subSegments.add(newSegment);
        toExplore.add(newSegment);
      }

    }

    var lowestPrice = 999999999999999;
    for (final path in correctPaths) {
      var currentScore = 0;
      var currentDir = null;
      for(final pos in path) {
        if (currentDir != null && currentDir != pos.direction) {
          currentScore += 1001;
        } else {
          currentScore += 1;
        }
        currentDir = pos.direction;
      }

      print('score: $currentScore');
      lowestPrice = [lowestPrice, currentScore].reduce(math.min);
    }

    return lowestPrice;
  }

  @override
  int solvePart2() {

    return 0;
  }
}

