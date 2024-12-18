import 'dart:io';

import '../utils/index.dart';
import 'day07.dart';

enum OPCode { adv, bxl, bst, jnz, bxc, out, bdv, cdv }

class Program {
  int a;
  int b;
  int c;
  List<int> program;
  int currentInstruction = 0;
  List<int> outputs = [];

  Program(this.program, this.a, this.b, this.c);
}

class Day17 extends GenericDay {
  Day17() : super(17);

  @override
  Program parseInput() {
    final file = File('input/aoc17x.txt');
    final content = file.readAsStringSync();

    // Parse the input
    var a = 0;
    var b = 0;
    var c = 0;
    var program = <int>[];

    for (var line in content.split('\n')) {
      line = line.trim(); // Remove whitespace
      if (line.startsWith('Register A:')) {
        a = int.parse(line.split(':')[1].trim());
      } else if (line.startsWith('Register B:')) {
        b = int.parse(line.split(':')[1].trim());
      } else if (line.startsWith('Register C:')) {
        c = int.parse(line.split(':')[1].trim());
      } else if (line.startsWith('Program:')) {
        program = line.split(':')[1].trim().split(',').map(int.parse).toList();
      }
    }

    // Initialize the Program class
    return Program(program, a, b, c);
  }


  void executeOPCode(OPCode code, int operand, Program program) {
    switch(code) {
      case OPCode.adv:
        final numerator = program.a;
        final denominator = 2.pow(getValuePerOperand(operand, program));

        program.a = (numerator/denominator).truncate();
      case OPCode.bxl:
        program.b = program.b^operand;
      case OPCode.bst:
        program.b = getValuePerOperand(operand, program) % 8;
      case OPCode.jnz:
        if (program.a != 0) {
          program.currentInstruction = operand;
          return;
        }
      case OPCode.bxc:
        program.b = program.b ^ program.c;
      case OPCode.out:
        program.outputs.add(getValuePerOperand(operand, program)%8);
      case OPCode.bdv:
        final numerator = program.a;
        final denominator = 2.pow(getValuePerOperand(operand, program));

        program.b = (numerator/denominator).truncate();
      case OPCode.cdv:
        final numerator = program.a;
        final denominator = 2.pow(getValuePerOperand(operand, program));

        program.c = (numerator/denominator).truncate();
    }

    program.currentInstruction += 2;
  }

  int getValuePerOperand(int operand, Program program) {
    switch (operand) {
      case 0:
      case 1:
      case 2:
      case 3:
        return operand;
      case 4:
        return program.a;
      case 5:
        return program.b;
      case 6:
        return program.c;
      case 7:
        throw Exception('Invalid operand $operand');
      default:
        throw Exception('Out of bounds operand $operand');
    }
  }

  @override
  int solvePart1() {
    final program = parseInput();
    try {
      while(true) {
        final instruction = program.program[program.currentInstruction];
        final code = OPCode.values[instruction];
        final operand = program.program[program.currentInstruction + 1];

        executeOPCode(code, operand, program);
      }
    } catch (e) {
      final result = program.outputs.join(',');
      print('SOLUTION IS : $result');
    }

    return 0;
  }

  @override
  int solvePart2() {
    var program = parseInput();

    var hasFoundSolution = false;
    var iteration = 10096774265;
    program.a = iteration;

    while (!hasFoundSolution) {
      print('Iteration $iteration');
      try {
        while(true) {
          final instruction = program.program[program.currentInstruction];
          final code = OPCode.values[instruction];
          final operand = program.program[program.currentInstruction + 1];

          executeOPCode(code, operand, program);
        }
      } catch (e) {
        final result = program.outputs.join(',');
        if (result == program.program.join(',')) {
          hasFoundSolution = true;
          print('SOLUTION IS : $iteration');
        } else {
          iteration++;
          program = parseInput();
          program.a = iteration;
        }
      }
    }

      return 0;
  }
}
