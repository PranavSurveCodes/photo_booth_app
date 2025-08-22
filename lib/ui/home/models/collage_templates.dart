class CollageTemplate {
  final List<CollageSlot> slots;
  CollageTemplate(this.slots);
}

class CollageSlot {
  final double x;
  final double y;
  final double width;
  final double height;
  CollageSlot(this.x, this.y, this.width, this.height);
}

final templates = [
  // Layout 1: Two on top, one wide bottom
  CollageTemplate([
    CollageSlot(0, 0, 0.5, 0.5),
    CollageSlot(0.5, 0, 0.5, 0.5),
    CollageSlot(0, 0.5, 1.0, 0.5),
  ]),

  // Layout 2: One tall left, two stacked right
  CollageTemplate([
    CollageSlot(0, 0, 0.5, 1.0),
    CollageSlot(0.5, 0, 0.5, 0.5),
    CollageSlot(0.5, 0.5, 0.5, 0.5),
  ]),

  // Layout 3: One wide top, two at bottom
  CollageTemplate([
    CollageSlot(0, 0, 1.0, 0.5),
    CollageSlot(0, 0.5, 0.5, 0.5),
    CollageSlot(0.5, 0.5, 0.5, 0.5),
  ]),

  // Layout 4: One tall right, two stacked left
  CollageTemplate([
    CollageSlot(0.5, 0, 0.5, 1.0),
    CollageSlot(0, 0, 0.5, 0.5),
    CollageSlot(0, 0.5, 0.5, 0.5),
  ]),

  // Layout 5: Four equal quadrants
  CollageTemplate([
    CollageSlot(0, 0, 0.5, 0.5),
    CollageSlot(0.5, 0, 0.5, 0.5),
    CollageSlot(0, 0.5, 0.5, 0.5),
    CollageSlot(0.5, 0.5, 0.5, 0.5),
  ]),

  // Layout 6: Big left (60%), two stacked right
  CollageTemplate([
    CollageSlot(0, 0, 0.6, 1.0),
    CollageSlot(0.6, 0, 0.4, 0.5),
    CollageSlot(0.6, 0.5, 0.4, 0.5),
  ]),

  // Layout 7: Big top (60%), two below
  CollageTemplate([
    CollageSlot(0, 0, 1.0, 0.6),
    CollageSlot(0, 0.6, 0.5, 0.4),
    CollageSlot(0.5, 0.6, 0.5, 0.4),
  ]),

  // Layout 8: Three equal vertical columns
  CollageTemplate([
    CollageSlot(0, 0, 0.33, 1.0),
    CollageSlot(0.33, 0, 0.34, 1.0),
    CollageSlot(0.67, 0, 0.33, 1.0),
  ]),

  // Layout 9: 3x3 full grid
  CollageTemplate([
    CollageSlot(0.0, 0.0, 0.33, 0.33),
    CollageSlot(0.33, 0.0, 0.34, 0.33),
    CollageSlot(0.67, 0.0, 0.33, 0.33),
    CollageSlot(0.0, 0.33, 0.33, 0.34),
    CollageSlot(0.33, 0.33, 0.34, 0.34),
    CollageSlot(0.67, 0.33, 0.33, 0.34),
    CollageSlot(0.0, 0.67, 0.33, 0.33),
    CollageSlot(0.33, 0.67, 0.34, 0.33),
    CollageSlot(0.67, 0.67, 0.33, 0.33),
  ]),

  // Layout 10: Center focus - one big middle, four corners
  CollageTemplate([
    CollageSlot(0.25, 0.25, 0.5, 0.5),  // Big center
    CollageSlot(0, 0, 0.25, 0.25),      // Top-left
    CollageSlot(0.75, 0, 0.25, 0.25),   // Top-right
    CollageSlot(0, 0.75, 0.25, 0.25),   // Bottom-left
    CollageSlot(0.75, 0.75, 0.25, 0.25) // Bottom-right
  ]),
];
