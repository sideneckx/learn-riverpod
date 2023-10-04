import 'package:flutter_riverpod/flutter_riverpod.dart';

final countGetterProvider = Provider((ref) {
  final counter = ref.watch(counterGetSetProvider);
  return counter;
});

final counterGetSetProvider = StateProvider((ref) => 0);
