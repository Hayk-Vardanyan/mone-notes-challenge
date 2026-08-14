extension SpreadMethod on List {
  List<T> spread<T>(T Function(int index) generator) {
    if (isEmpty) {
      return this as List<T>;
    }

    var index = 0;

    return expand((element) {
      return <T>[element, generator(index++)];
    }).toList()
      ..removeLast();
  }

  bool equals(List list) {
    if (length != list.length) {
      return false;
    }
    return every((item) => list.contains(item));
  }
}
