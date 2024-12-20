import 'dart:io';

import '../utils/index.dart';
import '../utils/maze.dart';
import '../utils/pair.dart';

class Shortcut {
  final Pos start;
  final Pos end;
  final Pos wall;

  Shortcut(this.start, this.end, this.wall);

  @override
  String toString() {
    return 'Shortcut{start: $start, end: $end, wall: $wall}';
  }
}

class Day20 extends GenericDay {
  Day20() : super(20);

  @override
  String parseInput() {
    final file = File('input/aoc20.txt');
    // final file = File('input/aoc20x.txt');
    return file.readAsStringSync();
  }

  List<Pos> getPath(Maze maze, Pos startPos, Pos endPos) {
    final track = <Pos>[startPos];
    final queue = <Pos>[startPos];
    final visited = <Pos>{};

    while (queue.isNotEmpty) {
      final pos = queue.removeAt(0);
      if (pos == endPos) {
        break;
      }

      for (final neighborPos in maze.getNeighborsPos(pos)) {
        if (visited.contains(neighborPos)) {
          continue;
        }

        final element = maze.grid[neighborPos.x][neighborPos.y];
        if (element == '#') {
          continue;
        }

        if (element == '.' || element == 'E') {
          track.add(neighborPos);
        }

        visited.add(neighborPos);
        queue.add(neighborPos);
      }
    }

    return track;
  }

  // Return a Shortcut as Pair of Pos
  // First Pos = Shortcut
  // Second Pos = track reached
  List<Shortcut> getShortcuts(Maze track, Pos pos) {
    final shortcuts = List<Shortcut>.empty(growable: true);
    for (final dir in Maze.directions) {
      try {
        final shortcutPos = Pos(pos.x + dir[0], pos.y + dir[1]);
        final trackPos = Pos(pos.x + dir[0]*2, pos.y + dir[1]*2);

        if (track.grid[shortcutPos.x][shortcutPos.y] == '#' && (track.grid[trackPos.x][trackPos.y] == '.' || track.grid[trackPos.x][trackPos.y] == 'E')) {
          shortcuts.add(Shortcut(pos, trackPos, shortcutPos));
        }
      } catch (e) {
        continue;
      }
    }


    return shortcuts;
  }

  // Remove the bi-directional shortcuts to keep only one
  void cleanupShortcuts(List<Shortcut> shortcuts) {
    for (var i = 0; i < shortcuts.length; i++) {
      final shortcut = shortcuts[i];
      for (var j = i + 1; j < shortcuts.length; j++) {
        final other = shortcuts[j];
        if (shortcut.start == other.end && shortcut.end == other.start) {
          shortcuts.removeAt(j);
          break;
        }
      }
    }
  }

  @override
  int solvePart1() {
    final input = parseInput();
    final track = Maze(input);
    final start = track.getPosOf('S');
    final end = track.getPosOf('E');

    final path = getPath(track, start, end);

    final shortcuts = List<Shortcut>.empty(growable: true);
    for (var i = 0; i < path.length; i++) {
      final currentPos = path[i];
      shortcuts.addAll(getShortcuts(track, currentPos));
    }

    cleanupShortcuts(shortcuts);

    var count = 0;
    for (final shortcut in shortcuts) {
      final firstIndex = path.indexOf(shortcut.start);
      final secondIndex = path.indexOf(shortcut.end);
      final diff = (secondIndex - firstIndex).abs() - 2;


      if (diff >= 100) {
        print('Found big $shortcut of $diff');
        count++;
      }
    }

    // 2907 too high
    return count;
  }

  @override
  int solvePart2() {

    return 0;
  }
}

