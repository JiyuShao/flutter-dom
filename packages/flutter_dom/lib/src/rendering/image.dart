/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'dart:ui' as ui show Image;
import 'package:flutter/rendering.dart';

class FlutterDomRenderImage extends RenderImage {
  FlutterDomRenderImage({
    ui.Image? image,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
  }) : super(
          image: image,
          fit: fit,
          alignment: alignment,
        );

  @override
  void performLayout() {
    Size trySize = constraints.biggest;
    size = trySize.isInfinite ? constraints.smallest : trySize;
  }
}
