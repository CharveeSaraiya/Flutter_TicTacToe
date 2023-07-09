import 'dart:math';

enum TileState { NONE, EMPTY, CROSS, CIRCLE, DRAW }

List<List<TileState>> chunk(List<TileState> list, int size) {
  return List.generate(
      (list.length / size).ceil(),
      (index) =>
          list.sublist(index * size, min(index * size + size, list.length)));
}
