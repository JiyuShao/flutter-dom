/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */

import 'dart:core';

import 'package:flutter/rendering.dart';
import 'package:flutter_dom/css.dart';

// CSS Box Model: https://drafts.csswg.org/css-box-4/
mixin CSSBoxMixin on RenderStyle {
  final DecorationPosition decorationPosition = DecorationPosition.background;
  final ImageConfiguration imageConfiguration = ImageConfiguration.empty;

  /// What decoration to paint, should get value after layout.
  CSSBoxDecoration? get decoration {
    List<Radius>? radius = this.borderRadius;
    List<BorderSide>? borderSides = this.borderSides;

    if (backgroundColor == null &&
        backgroundImage == null &&
        borderSides == null &&
        radius == null &&
        shadows == null) {
      return null;
    }

    Border? border;
    if (borderSides != null) {
      // Side read inorder left top right bottom.
      border = Border(left: borderSides[0], top: borderSides[1], right: borderSides[2], bottom: borderSides[3]);
    }

    BorderRadius? borderRadius;
    // Flutter border radius only works when border is uniform.
    if (radius != null && (border == null || border.isUniform)) {
      borderRadius = BorderRadius.only(
        topLeft: radius[0],
        topRight: radius[1],
        bottomRight: radius[2],
        bottomLeft: radius[3],
      );
    }

    Gradient? gradient = backgroundImage?.gradient;
    if (gradient is BorderGradientMixin && border != null) {
      gradient.borderEdge = border.dimensions as EdgeInsets;
    }

    DecorationImage? decorationImage;
    ImageProvider? image = backgroundImage?.image;
    if (image != null) {
      decorationImage = DecorationImage(
        image: image,
        repeat: backgroundRepeat,
      );
    }

    return CSSBoxDecoration(
      boxShadow: shadows,
      color: gradient != null ? null : backgroundColor, // FIXME: chrome will work with gradient and color.
      image: decorationImage,
      border: border,
      borderRadius: borderRadius,
      gradient: gradient,
    );
  }
}

class CSSBoxDecoration extends BoxDecoration {
  CSSBoxDecoration({
    this.color,
    this.image,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.backgroundBlendMode,
    this.shape = BoxShape.rectangle,
  }) : super(
            color: color,
            image: image,
            border: border,
            borderRadius: borderRadius,
            gradient: gradient,
            backgroundBlendMode: backgroundBlendMode,
            shape: shape);

  @override
  final Color? color;

  @override
  final DecorationImage? image;

  @override
  final BoxBorder? border;

  @override
  final BorderRadius? borderRadius;

  @override
  final List<FlutterDomBoxShadow>? boxShadow;

  @override
  final Gradient? gradient;

  @override
  final BlendMode? backgroundBlendMode;

  @override
  final BoxShape shape;

  bool get hasBorderRadius => borderRadius != null && borderRadius != BorderRadius.zero;

  CSSBoxDecoration clone({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadius? borderRadius,
    List<FlutterDomBoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
  }) {
    return CSSBoxDecoration(
      color: color ?? this.color,
      image: image ?? this.image,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      gradient: gradient ?? this.gradient,
      backgroundBlendMode: backgroundBlendMode ?? this.backgroundBlendMode,
      shape: shape ?? this.shape,
    );
  }
}
