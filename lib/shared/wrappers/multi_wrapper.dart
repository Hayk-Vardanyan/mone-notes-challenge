import 'package:nested/nested.dart';

class MultiWrapper extends Nested {
  MultiWrapper({
    super.key,
    required List<SingleChildWidget> wrappers,
    required super.child,
  }) : super(children: wrappers);
}
