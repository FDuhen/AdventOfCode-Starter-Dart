List<List<int>> stringToIntMap(String content) {
  try {
    final lines = content.split('\n');
    return lines
        .map(
          (e) => e.split('').map(int.parse).toList(),
        )
        .toList();
  } catch (e) {
    print(e);
    return [];
  }
}

List<List<String>> stringToStringMap(String content) {
  try {
    final lines = content.split('\n');
    return lines.map((e) => e.split('').toList()).toList();
  } catch (e) {
    print(e);
    return [];
  }
}
