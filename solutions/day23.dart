import 'dart:io';

import '../utils/index.dart';

class Holder {
  final Set<String> names;

  Holder(this.names);

  @override
  int get hashCode {
    return names.map((e) => e.hashCode).reduce((v, e) => v + e);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Holder &&
        other.names.length == names.length && other.hashCode == hashCode;
  }

  @override
  String toString() {
    return 'Holder{$names}';
  }

  String hasCommon(Holder other) {
    final common = names.intersection(other.names);
    return common.isEmpty ? '' : common.first;
  }

  bool isValid() {
    for (var i = 0; i < names.length; i++) {
      final name = names.elementAt(i);
      if (name.startsWith('t')) {
        return true;
      }
    }

    return false;
  }

  bool containsPair(String first, String second) =>
      names.contains(first) && names.contains(second);

  void add(String name) {
    names.add(name);
  }
}

class Day23 extends GenericDay {
  Day23() : super(23);
  final file = File('input/aoc23.txt');

  @override
  List<Holder> parseInput() {
    final data = file.readAsStringSync().split('\n').toList();

    return data.map((e){
      final parts = e.split('-');
      return Holder(parts.toSet());
    }).toList();
  }

  Set<String> getUniqueComputers() {
    final data = file.readAsStringSync().split('\n').toList();
    final set = <String>{};

    for (var i = 0; i < data.length; i++) {
      final parts = data[i].split('-');
      set..add(parts[0])..add(parts[1]);
    }

    return set;
  }

  @override
  int solvePart1() {
    final pairs = parseInput();

    final dict = <String, Set<String>>{};
    final computers = getUniqueComputers();

    for (var i = 0; i < computers.length; i++) {
      final computer = computers.elementAt(i);

      for (var j = 0; j < pairs.length; j++) {
        final holder = pairs[j];
        if (holder.names.contains(computer)) {
          dict[computer] ??= <String>{};
          for(final name in holder.names) {
            if (name != computer) {
              dict[computer]!.add(name);
            }
          }
        }
      }
    }

    final validHolders = <Holder>{};
    for (var i = 0; i < pairs.length; i++) {
      final holder = pairs.elementAt(i);
      final firstSet = dict[holder.names.first];
      final secSet = dict[holder.names.last];

      if (firstSet != null && secSet != null) {
        final commons = firstSet.intersection(secSet);
        for (final common in commons) {
          final set = <String>{}
            ..addAll(holder.names)
            ..add(common);
          validHolders.add(Holder(set));
        }
      }
    }

    return validHolders.where((e) => e.names.length >= 3 && e.isValid()).length;
  }

  @override
  int solvePart2() {
    final pairs = parseInput();

    final dict = <String, Set<String>>{};
    final computers = getUniqueComputers();

    for (var i = 0; i < computers.length; i++) {
      final computer = computers.elementAt(i);

      for (var j = 0; j < pairs.length; j++) {
        final holder = pairs[j];
        if (holder.names.contains(computer)) {
          dict[computer] ??= <String>{};
          for(final name in holder.names) {
            if (name != computer) {
              dict[computer]!.add(name);
            }
          }
        }
      }
    }

    final validHolders = <Holder>{};
    for (final computer in dict.entries) {
      final connections = computer.value;
      for (final connection in connections) {
        final existingGroups = validHolders
            .where((g) => g.containsPair(computer.key, connection))
            .toList();

        if (existingGroups.isEmpty) {
          final set = <String>{}
            ..add(computer.key)
            ..add(connection);
          final group = Holder(set);
          validHolders.add(group);
          continue;
        }

        for (final existingGroup in existingGroups) {
          final allPotentialConnections = existingGroup.names
              .fold(<String>{}, (e, v) => e.union(dict[v]!)).where(
                  (c) => !existingGroup.names.contains(c));

          for (final potentialConnection in allPotentialConnections) {
            if (existingGroup.names
                .every((c) => dict[c]!.contains(potentialConnection))) {
              validHolders.remove(existingGroup);
              existingGroup.add(potentialConnection);
              validHolders.add(existingGroup);
            }
          }
        }
      }
    }

    final biggestHolder = validHolders
        .sorted((a, b) => b.names.length.compareTo(a.names.length))
        .first;

    print(biggestHolder.names.sorted((a, b) => a.compareTo(b),).join(','));
    return 0;
  }
}

