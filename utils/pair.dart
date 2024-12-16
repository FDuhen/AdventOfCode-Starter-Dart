class Pair<F, S> {
  Pair(this.first, this.second);

  final F first;
  final S second;

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }
}
