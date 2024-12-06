import 'dart:collection';
import 'dart:io';

import '../utils/index.dart';

class Player {
  Player(this.position, this.currentDir);

  Map<int, int> position;
  String currentDir;

  String getStringPos() {
    return '${position.keys.first};${position.values.first}';
  }
}

class Day06 extends GenericDay {
  Day06() : super(6);

  static const dirTop = '^';
  static const dirLeft = '<';
  static const dirRight = '>';
  static const dirBottom = 'v';

  @override
  String parseInput() {
    final file = File('input/aoc06.txt');
    try {
      final content = file.readAsStringSync();
      return content;
    } catch (e) {
      return '';
    }
  }

  @override
  int solvePart1() {
    List<List<String>> map = _parseMap();

    final updatedMap = map;
    final playerInfos = getPlayerInfos(updatedMap);
    final travelPositions = <String>{}..add(playerInfos.getStringPos());

    try {
      while (true) {
        if (playerInfos.currentDir == dirTop) {
          if (canGoUp(playerInfos.position, updatedMap)) {
            // Update the player position
            playerInfos.position = {playerInfos.position.keys.first - 1: playerInfos.position.values.first};
            // Move him across the map
            updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
            // Log the move
            travelPositions.add(playerInfos.getStringPos());
          } else {
            // Update the player direction
            playerInfos.currentDir = dirRight;
            updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
          }
        } else if (playerInfos.currentDir == dirRight) {
          if (canGoRight(playerInfos.position, updatedMap)) {
            playerInfos.position = {playerInfos.position.keys.first: playerInfos.position.values.first + 1};
            updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
            travelPositions.add(playerInfos.getStringPos());
          } else {
            playerInfos.currentDir = dirBottom;
            updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
          }
        } else if (playerInfos.currentDir == dirBottom) {
          if (canGoDown(playerInfos.position, updatedMap)) {
            playerInfos.position = {playerInfos.position.keys.first + 1: playerInfos.position.values.first};
            updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
            travelPositions.add(playerInfos.getStringPos());
          } else {
            playerInfos.currentDir = dirLeft;
            updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
          }
        } else if (playerInfos.currentDir == dirLeft) {
          if (canGoLeft(playerInfos.position, updatedMap)) {
            playerInfos.position = {playerInfos.position.keys.first: playerInfos.position.values.first - 1};
            updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
            travelPositions.add(playerInfos.getStringPos());
          } else {
            playerInfos.currentDir = dirTop;
            updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
          }
        }
      }
    } catch (e) {
      // Should be out of bounds exception
      print(e);
    }

    var res = 0;
    for (var i = 0; i < updatedMap.length; i++) {
      for (var j = 0; j < updatedMap[i].length; j++) {
        if (updatedMap[i][j] == dirTop ||
            updatedMap[i][j] == dirLeft ||
            updatedMap[i][j] == dirRight ||
            updatedMap[i][j] == dirBottom) {
          res++;
        }
      }
    }


    return res;
  }

  Player getPlayerInfos(List<List<String>> map) {
    for (var i = 0; i < map.length; i++) {
      for (var j = 0; j < map[i].length; j++) {
        if (map[i][j] == dirTop ||
            map[i][j] == dirLeft ||
            map[i][j] == dirRight ||
            map[i][j] == dirBottom) {
          return Player({i: j}, map[i][j]);
        }
      }
    }

    throw Exception();
  }

  bool canGoUp(Map<int, int> position, List<List<String>> updatedMap) {
    return updatedMap[position.keys.first - 1][position.values.first] != '#';
  }

  bool canGoDown(Map<int, int> position, List<List<String>> updatedMap) {
    return updatedMap[position.keys.first + 1][position.values.first] != '#';
  }

  bool canGoLeft(Map<int, int> position, List<List<String>> updatedMap) {
    return updatedMap[position.keys.first][position.values.first - 1] != '#';
  }

  bool canGoRight(Map<int, int> position, List<List<String>> updatedMap) {
    return updatedMap[position.keys.first][position.values.first + 1] != '#';
  }

  @override
  int solvePart2() {
    final map = _parseMap();
    final initialPlayerInfos = getPlayerInfos(map);

    var rewalkCounts = 0;

    for (var i = 0; i < map.length; i++) {
      for (var j = 0; j < map[i].length; j++) {
        if (initialPlayerInfos.position.keys.first == i && initialPlayerInfos.position.values.first == j) {
          print('On initial player position, continue');
          continue;
        }

        // print('Blocking a new position, resetting everything');
        final updatedMap = _parseMap();
        final playerInfos = getPlayerInfos(updatedMap);
        final travelPositions = {playerInfos.getStringPos(): 1};
        updatedMap[i][j] = '#';
        // print(updatedMap);
        var loopIn = true;

        try {
           while (loopIn) {
            if (playerInfos.currentDir == dirTop) {
              if (canGoUp(playerInfos.position, updatedMap)) {
                // Update the player position
                playerInfos.position = {playerInfos.position.keys.first - 1: playerInfos.position.values.first};
                // Move him across the map
                updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
                // Log the move
                // travelPositions.update(playerInfos.getStringPos(), (value) => value++, ifAbsent: () => 1);
              } else {
                // Update the player direction
                playerInfos.currentDir = dirRight;
                updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
              }
            } else if (playerInfos.currentDir == dirRight) {
              if (canGoRight(playerInfos.position, updatedMap)) {
                playerInfos.position = {playerInfos.position.keys.first: playerInfos.position.values.first + 1};
                updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
              } else {
                playerInfos.currentDir = dirBottom;
                updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
              }
            } else if (playerInfos.currentDir == dirBottom) {
              if (canGoDown(playerInfos.position, updatedMap)) {
                playerInfos.position = {playerInfos.position.keys.first + 1: playerInfos.position.values.first};
                updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
                // Log the move
                // travelPositions.update(playerInfos.getStringPos(), (value) => value++, ifAbsent: () => 1);
              } else {
                playerInfos.currentDir = dirLeft;
                updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
              }
            } else if (playerInfos.currentDir == dirLeft) {
              if (canGoLeft(playerInfos.position, updatedMap)) {
                playerInfos.position = {playerInfos.position.keys.first: playerInfos.position.values.first - 1};
                updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
                // Log the move
                // travelPositions.update(playerInfos.getStringPos(), (value) => value++, ifAbsent: () => 1);
              } else {
                playerInfos.currentDir = dirTop;
                updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first] = playerInfos.currentDir;
              }
            }

            // Log the move
            travelPositions.update(playerInfos.getStringPos(), (value) => value = value+1, ifAbsent: () => 1);

            if (isRewalking(updatedMap, playerInfos, travelPositions)) {
              print('Rewalking detected');
              rewalkCounts++;
              loopIn = false;
            }
          }
        } catch (e) {
          // Should be out of bounds exception
          // print(e);
        }
      }
    }


    return rewalkCounts;
  }

  List<List<String>> _parseMap() {
    final lines = parseInput().split('\n');
    final map = lines
        .map(
          (e) => e.split(''),
    )
        .toList();
    return map;
  }

  bool isRewalking(List<List<String>> updatedMap, Player playerInfos, Map<String, int> positionsHistory) {

    for (final value in positionsHistory.values) {
      if (value > 10) {
        return true;
      }
    }

    // Check if the player next position is already visited with the same direction
    if (playerInfos.currentDir == dirTop) {
      return updatedMap[playerInfos.position.keys.first - 1][playerInfos.position.values.first] == dirTop;
    } else if (playerInfos.currentDir == dirRight) {
      return updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first + 1] == dirRight;
    } else if (playerInfos.currentDir == dirBottom) {
      return updatedMap[playerInfos.position.keys.first + 1][playerInfos.position.values.first] == dirBottom;
    } else if (playerInfos.currentDir == dirLeft) {
      return updatedMap[playerInfos.position.keys.first][playerInfos.position.values.first - 1] == dirLeft;
    }

    return false;
  }
}
