import 'dart:io';

import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  String parseInput() {
    final file = File('input/aoc05.txt');
    try {
      final content = file.readAsStringSync();
      return content;
    } catch (e) {
      return '';
    }
  }

  String parseInputBis() {
    final file = File('input/aoc05_b.txt');
    try {
      final content = file.readAsStringSync();
      return content;
    } catch (e) {
      return '';
    }
  }

  @override
  int solvePart1() {
    final ordersString = parseInput();
    final listsToCheckString = parseInputBis();

    final ordersRows = ordersString.split('\n');
    final ordersList = ordersRows.map((e) => e.split('|').map(int.parse).toList()).toList();
    assert(ordersList.length == 1176, 'Error while parsing');

    final listToCheckRows = listsToCheckString.split('\n');
    final listToCheck = listToCheckRows.map((e) => e.split(',').map(int.parse).toList());
    assert(listToCheck.length == 223, 'Error while parsing');

    var count = 0;
    for (final line in listToCheck) {
      var isValid = true;
      for (var i = 0; i < line.length; i++) {
        final current = line[i];
        if (!respectRule(current, line.take(i).toList(), ordersList)) {
          isValid = false;
        }
      }

      if (isValid) {
        final middleIndex = (line.length / 2).floor();
        count += line[middleIndex];
      }
    }

    return count;
  }

  bool respectRule(int currentNumber, List<int> previousNumbers, List<List<int>> rules) {
    for (final previousNumber in previousNumbers) {
      for (var i = 0; i < rules.length; i ++) {
        if (rules[i].first == currentNumber && rules[i][1] == previousNumber) {
          return false;
        }
      }
    }

    return true;
  }

  List<int> fixedOrder(int currentNumber, List<int> previousNumbers, List<List<int>> rules) {
    List<int> finalList = [...previousNumbers];

    for (var k = 0; k < previousNumbers.length; k++) {
      for (var i = 0; i < rules.length; i ++) {
        if (rules[i].first == currentNumber && rules[i][1] == previousNumbers[k]) {
          finalList..removeWhere((e) => e == currentNumber)
          ..insert(k, currentNumber);
          return fixedOrder(finalList.last, finalList, rules);
        }
      }
    }


    return finalList;
  }

  @override
  int solvePart2() {
    final ordersString = parseInput();
    final listsToCheckString = parseInputBis();

    final ordersRows = ordersString.split('\n');
    final ordersList = ordersRows.map((e) => e.split('|').map(int.parse).toList()).toList();
    assert(ordersList.length == 1176, 'Error while parsing');

    final listToCheckRows = listsToCheckString.split('\n');
    final listToCheck = listToCheckRows.map((e) => e.split(',').map(int.parse).toList());
    assert(listToCheck.length == 223, 'Error while parsing');

    final listsToFix = <List<int>>[];
    for (final line in listToCheck) {
      var isValid = true;
      for (var i = 0; i < line.length; i++) {
        final current = line[i];
        if (!respectRule(current, line.take(i).toList(), ordersList)) {
          isValid = false;
        }
      }

      if (!isValid) {
        listsToFix.add(line);
      }
    }
    print('${listsToFix.length}');


    var fixedToCheck = <List<int>>[];
    for (var i = 0; i < listsToFix.length; i ++) {

      var currentLine = <int>[];
      for (var j = 0; j < listsToFix[i].length; j++) {
        currentLine.add(listsToFix[i][j]);
        print('$currentLine');
        currentLine = fixedOrder(listsToFix[i][j], currentLine, ordersList);
      }

      fixedToCheck.add(currentLine);
    }


    var count = 0;
    for (final line in fixedToCheck) {
      var isValid = true;
      for (var i = 0; i < line.length; i++) {
        final current = line[i];
        if (!respectRule(current, line.take(i).toList(), ordersList)) {
          isValid = false;
        }
      }

      if (isValid) {
        final middleIndex = (line.length / 2).floor();
        count += line[middleIndex];
      }
    }

    return count;
  }
}

