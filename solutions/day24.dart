import 'dart:io';

import '../utils/index.dart';
import '../utils/pair.dart';

enum Operators {
  xor('XOR'),
  or('OR'),
  and('AND');

  const Operators(this.value);
  final String value;
}

extension StringExt24 on String {
  Operators toOperator() {
    switch (this) {
      case 'XOR':
        return Operators.xor;
      case 'OR':
        return Operators.or;
      case 'AND':
        return Operators.and;
      default:
        throw Exception('Invalid operator');
    }
  }
}

class Instruction {
  final Operators operator;
  final Set<String> inputsNames;
  final String outputName;

  Instruction(this.operator, this.inputsNames, this.outputName);
}

class Game {
  final List<Pair<String, int>> inputs;
  final List<Instruction> instructions;

  Game(this.inputs, this.instructions);
}

class Day24 extends GenericDay {
  Day24() : super(24);

  @override
  Game parseInput() {
    final file = File('input/aoc24.txt');
    final data = file.readAsStringSync().split('\n\n').toList();

    final objInputs = <Pair<String, int>>[];
    final insructions = <Instruction>[];

    for (final input in data[0].split('\n')) {
      final parts = input.split(': ');
      objInputs.add(Pair(parts[0], int.parse(parts[1])));
    }

    for (final input in data[1].split('\n')) {
      final parts = input.split(' -> ');
      final currentOutput = parts[1];
      final arrayInst = parts[0].split(' ');
      insructions.add(Instruction(arrayInst[1].toOperator(), Set.from([arrayInst[0], arrayInst[2]]), currentOutput));
    }

    return Game(objInputs, insructions);
  }

  @override
  int solvePart1() {
    final game = parseInput();

    final queue = [...game.instructions];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      if (current.inputsNames.every((element) => game.inputs.any((e) => e.first == element))) {
        final inputs = current.inputsNames.map((e) => game.inputs.firstWhere((element) => element.first == e).second).toList();
        final result = current.operator == Operators.and ? inputs[0] & inputs[1] : current.operator == Operators.or ? inputs[0] | inputs[1] : inputs[0] ^ inputs[1];
        game.inputs.add(Pair(current.outputName, result));
      } else {
        queue.add(current);
      }
    }

    final res = game.inputs
        .where((element) => element.first.startsWith('z'))
        .sorted(
          (a, b) => b.first.compareTo(a.first),
        )
        .map(
          (e) => e.second,
        )
        .join();


    return int.parse(res, radix: 2);
  }

  @override
  int solvePart2() {

    return 0;
  }
}

