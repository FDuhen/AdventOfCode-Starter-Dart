import 'dart:io';

import '../utils/index.dart';
import '../utils/maze.dart';

class Shortcut {
  final Pos start;
  final Pos end;
  final Pos wall;
  final int? cheatDistance;

  Shortcut(this.start, this.end, this.wall, {this.cheatDistance});

  @override
  String toString() {
    return 'Shortcut{start: $start, end: $end, wall: $wall}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shortcut &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end) ||
      (other is Shortcut &&
          runtimeType == other.runtimeType &&
          start == other.end &&
          end == other.start);

  @override
  int get hashCode => (start.hashCode ^ end.hashCode) + (end.hashCode ^ start.hashCode);
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


  // Return a Shortcut as Pair of Pos
  // First Pos = Shortcut
  // Second Pos = track reached
  List<Shortcut> getBigShortcuts(Maze track, Pos pos) {
    const maxShortcut = 20;
    // Creating a square of 20x20 around the current position and checking
    // All the values in it
    final rangeX = List.generate(
      maxShortcut * 2 + 1,
          (index) => index - maxShortcut,
    );
    final rangeY = [...rangeX];
    final shortcuts = List<Shortcut>.empty(growable: true);

    for (final x in rangeX) {
      for (final y in rangeY) {
        try {
          final shortcutPos = Pos(pos.x + x, pos.y + y);
          if (track.grid[shortcutPos.x][shortcutPos.y] == '.' || track.grid[shortcutPos.x][shortcutPos.y] == 'E') {
            if (isInRange(pos, shortcutPos, maxShortcut)) {
              final newShortcut = Shortcut(pos, shortcutPos, const Pos(-1, -1), cheatDistance: getDistance(pos, shortcutPos));
              if (!shortcuts.contains(newShortcut)) {
                shortcuts.add(newShortcut);
              }
            }
          }
        } catch (e) {
          continue;
        }

      }
    }

    return shortcuts;
  }


  bool isInRange(Pos pos, Pos shortcutPos, int maxShortcut) {
    return getDistance(pos, shortcutPos) <= maxShortcut;
  }

  int getDistance(Pos pos, Pos shortcutPos) => (pos.x - shortcutPos.x).abs() + (pos.y - shortcutPos.y).abs();

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
        count++;
      }
    }

    // 2907 too high
    return count;
  }

  @override
  int solvePart2() {
    final input = parseInput();
    final track = Maze(input);
    final start = track.getPosOf('S');
    final end = track.getPosOf('E');

    final path = getPath(track, start, end);

    final shortcuts = <Shortcut>{};
    for (var i = 0; i < path.length; i++) {
      final currentPos = path[i];
      shortcuts.addAll(getBigShortcuts(track, currentPos));
    }

    var count = 0;
    for (final shortcut in shortcuts) {
      final firstIndex = path.indexOf(shortcut.start);
      final secondIndex = path.indexOf(shortcut.end);
      final diff = (secondIndex - firstIndex).abs() - (shortcut.cheatDistance!);


      if (diff >= 100) {
        count++;
      }
    }

    // 2084322 too high
    // 997879
    return count;
  }
}

