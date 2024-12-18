class Pair<F, S> {
  Pair(this.first, this.second);

  final F first;
  final S second;


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pair<F, S> &&
      other.first == first &&
      other.second == second;
  }


  @override
  int get hashCode {
    return first.hashCode ^ second.hashCode;
  }

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }
}
