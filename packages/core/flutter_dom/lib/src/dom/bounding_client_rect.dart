/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
class BoundingClientRect {
  static const BoundingClientRect zero =
      BoundingClientRect(0, 0, 0, 0, 0, 0, 0, 0);

  final double x;
  final double y;
  final double width;
  final double height;
  final double top;
  final double right;
  final double bottom;
  final double left;

  const BoundingClientRect(this.x, this.y, this.width, this.height, this.top,
      this.right, this.bottom, this.left);

  Map<String, double> toJSON() {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'left': left,
      'top': top,
      'right': right,
      'bottom': bottom
    };
  }
}
