class Canvas {
  final int height, width;

  Canvas(int pHeight, int pWidth)
      : height = pHeight,
        width = pWidth {
    if (pHeight == null || pHeight < 0) {
      throw ArgumentError.value(pHeight, "pHeight", "must be > 0");
    }
    if (pWidth == null || pWidth < 0) {
      throw ArgumentError.value(pWidth, "pWidth", "must be > 0");
    }
  }
}
