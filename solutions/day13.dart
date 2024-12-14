import 'dart:io';

import '../utils/index.dart';
import '../utils/pair.dart';

class Line {
  Line(this.x, this.y);

  final int x;
  final int y;
}

class Result {
  Result(this.x, this.y);

  final int x;
  final int y;
}

class Equation {
  Equation(this.firstLine, this.secondLine, this.expectedResult);

  final Line firstLine;
  final Line secondLine;
  final Result expectedResult;
}

class Day13 extends GenericDay {
  Day13() : super(13);

  @override
  List<Equation> parseInput() {
    // Button A: X+99, Y+37
    // Button B: X+18, Y+26
    // Prize: X=9441, Y=5051
    final file = File('input/aoc13.txt');
    final buttonRegex = RegExp(r'Button (.*): X\+([0-9]*), Y\+([0-9]*)');
    final prizeRegex = RegExp('Prize: X=([0-9]*), Y=([0-9]*)');

    try {
      final content = file.readAsStringSync();
      final blocks = content.split('\n\n');
      final equations = <Equation>[];

      for (final block in blocks) {
        final lines = block.split('\n');

        final firstLineRegex = buttonRegex.firstMatch(lines[0]);
        final lineA = Line(int.parse(firstLineRegex!.group(2)!),
            int.parse(firstLineRegex.group(3)!));

        final secondLineRegex = buttonRegex.firstMatch(lines[1]);
        final lineB = Line(
          int.parse(secondLineRegex!.group(2)!),
          int.parse(secondLineRegex.group(3)!),
        );

        final priceRegex = prizeRegex.firstMatch(lines[2]);
        final result = Result(
          int.parse(priceRegex!.group(1)!),
          int.parse(priceRegex.group(2)!),
        );

        equations.add(Equation(lineA, lineB, result));
      }

      return equations;
    } catch (e) {
      return [];
    }
  }

  // Thank you Chat GPT for the help
  // Couldn't figure out how to solve this, the linear equations are far away
  // in my past and I didn't remember how to solve them
  Pair<double, double>? solveEquation(int xA, int xB, int yA, int yB, int resultX, int resultY) {
    final determinant = xA * yB - xB * yA;
    if (determinant == 0) {
      print('Determinant is 0, cannot solve the equation');
      return null;
    }

    final detX = resultX * yB - xB * resultY;
    final detY = xA * resultY - resultX * yA;

    return Pair(detX / determinant, detY / determinant);
  }


  @override
  int solvePart1() {
    final equations = parseInput();
    var price = 0;

    for (final equation in equations) {
      final result = solveEquation(
        equation.firstLine.x,
        equation.secondLine.x,
        equation.firstLine.y,
        equation.secondLine.y,
        equation.expectedResult.x,
        equation.expectedResult.y,
      );

      // Check the modulo here to verify if the result is an integer
      if (result != null && result.first % 1 == 0 && result.second %1 == 0) {
        price += (result.first.toInt() * 3) + result.second.toInt();
      }
    }

    return price;
  }

  @override
  int solvePart2() {
    final equations = parseInput();
    var price = 0;

    // Have to cleanup this and reuse the code above but I'm tired
    for (final equation in equations) {
      final result = solveEquation(
        equation.firstLine.x,
        equation.secondLine.x,
        equation.firstLine.y,
        equation.secondLine.y,
        equation.expectedResult.x + 10000000000000,
        equation.expectedResult.y + 10000000000000,
      );

      // Check the modulo here to verify if the result is an integer
      if (result != null && result.first % 1 == 0 && result.second %1 == 0) {
        price += (result.first.toInt() * 3) + result.second.toInt();
      }
    }

    return price;
  }
}
