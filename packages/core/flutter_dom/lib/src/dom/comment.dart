/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'package:flutter/rendering.dart';
import 'package:flutter_dom/dom.dart';

class Comment extends Node {
  Comment([context]) : super(NodeType.COMMENT_NODE, context);

  @override
  String get nodeName => '#comment';

  @override
  RenderBox? get renderer => null;

  // @TODO: Get data from bridge side.
  String get data => '';

  int get length => data.length;
}
