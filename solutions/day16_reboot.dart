import 'dart:io';

import '../utils/grid.dart';
import '../utils/index.dart';
import '../utils/utils.dart';

class Point {
  int x;
  int y;
  int d;
  int s;
  List<(int, int)> path;

  Point(this.x, this.y, this.d, this.s, this.path);
}

class Day16Bis extends GenericDay {
  Day16Bis() : super(16);

  @override
  List<List<String>> parseInput() {
    final file = File('input/aoc16.txt');
    final content = file.readAsStringSync();
    return stringToStringMap(content);
  }

  @override
  int solvePart1() {
    final input = parseInput();
    return 0;
  }

  @override
  int solvePart2() {
    final file = File('input/aoc16.txt');
    final content = file.readAsStringSync();
    final maze = Grid<String>.string(content, (e) => e);

    var start = (x: 0, y: 0);
    var end = (x: 0, y: 0);
    maze.every((x, y, e) {
      if (e == 'S') {
        start = (x: x, y: y);
      } else if (e == 'E') {
        end = (x: x, y: y);
      }
    });

    final directions = <(int, int), int>{
      (1, 0): 0,
      (0, 1): 1,
      (0, -1): 2,
      (-1, 0): 3,
    };

    final queue = HeapPriorityQueue<Point>((a, b) => a.s - b.s)
      ..add(Point(start.x, start.y, 0, 0, []));

    final visited = <(int, int, int), int>{};
    Point? best;
    final alternartive = <Point>[];
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      current.path.add((current.x, current.y));
      final here = (current.x, current.y, current.d);
      if (visited.containsKey(here)) {
        alternartive.add(current);
        continue;
      }
      visited[here] = current.s;
      if (end.x == current.x && end.y == current.y) {
        best = current;
        break;
      }

      maze.adjacent(current.x, current.y, (x, y, el) {
        final d = directions[(x - current.x, y - current.y)]!;
        if (el == '#' || (current.d == 0 && d == 3) || (current.d == 1 && d == 2)) {
          return;
        }
        final score = current.s + (d == current.d ? 1 : 1001);
        queue.add(Point(x, y, d, score, List.from(current.path)));
      });
    }

    final path = Set<(int, int)>.from(best!.path);
    final bestPaths = Set<(int, int)>.from(best.path);
    for (final test in alternartive) {
      final score = visited[(test.x, test.y, test.d)]!;
      if (path.contains(test.path.last) && test.s == score) {
        bestPaths.addAll(test.path);
      }
    }

    print('Part 2: ${bestPaths.length}');

    // 514 is too high
    // 433 is too low
    return bestPaths.length;
  }
}
