/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */

import 'package:flutter_dom/src/dom/event.dart';

class NativeFlutterDomInfo {
  external String? appName;
  external String? appVersion;
  external String? appRevision;
  external String? systemName;
}

class RawNativeEvent {
// Raw bytes represent the following fields.
//   NativeString *type;
//   int64_t bubbles;
//   int64_t cancelable;
//   int64_t timeStamp;
//   int64_t defaultPrevented;
//   void *target;
//   void *currentTarget;
  external Map<String, dynamic> bytes;

  external int length;
}

class RawNativeInputEvent {
// Raw bytes represent the following fields.
//   NativeString *type;
//   int64_t bubbles;
//   int64_t cancelable;
//   int64_t timeStamp;
//   int64_t defaultPrevented;
//   void *target;
//   void *currentTarget;
//   NativeString *inputType;
//   NativeString *data
  external Map<String, dynamic> bytes;

  external int length;
}

class RawNativeMediaErrorEvent {
// Raw bytes represent the following fields.
//   NativeString *type;
//   int64_t bubbles;
//   int64_t cancelable;
//   int64_t timeStamp;
//   int64_t defaultPrevented;
//   void *target;
//   void *currentTarget;
//   int64_t code;
//   NativeString *message;
  external Map<String, dynamic> bytes;

  external int length;
}

class RawNativeMessageEvent {
// Raw bytes represent the following fields.
//   NativeString *type;
//   int64_t bubbles;
//   int64_t cancelable;
//   int64_t timeStamp;
//   int64_t defaultPrevented;
//   void *target;
//   void *currentTarget;
//   NativeString *data;
//   NativeString *origin;
  external Map<String, dynamic> bytes;

  external int length;
}

//
class RawNativeCustomEvent {
// Raw bytes represent the following fields.
//   NativeString *type;
//   int64_t bubbles;
//   int64_t cancelable;
//   int64_t timeStamp;
//   int64_t defaultPrevented;
//   void *target;
//   void *currentTarget;
//   NativeString *detail;
  external Map<String, dynamic> bytes;

  external int length;
}

class RawNativeMouseEvent {
// Raw bytes represent the following fields.
//   NativeString *type;
//   int64_t bubbles;
//   int64_t cancelable;
//   int64_t timeStamp;
//   int64_t defaultPrevented;
//   void *target;
//   void *currentTarget;
//   double clientX;
//   double clientY;
//   double offsetX;
//   double offsetY;
  external Map<String, dynamic> bytes;

  external int length;
}

class RawNativeGestureEvent {
// Raw bytes represent the following fields.
//   NativeString *type;
//   int64_t bubbles;
//   int64_t cancelable;
//   int64_t timeStamp;
//   int64_t defaultPrevented;
//   void *target;
//   void *currentTarget;
//   NativeString *state;
//   NativeString *direction;
//   double deltaX;
//   double deltaY;
//   double velocityX;
//   double velocityY;
//   double scale;
//   double rotation;
  external Map<String, dynamic> bytes;

  external int length;
}

class RawNativeCloseEvent {
// Raw bytes represent the following fields.
//   NativeString *type;
//   int64_t bubbles;
//   int64_t cancelable;
//   int64_t timeStamp;
//   int64_t defaultPrevented;
//   void *target;
//   void *currentTarget;
//   int64_t code;
//   NativeString *reason;
//   int64_t wasClean;
  external Map<String, dynamic> bytes;

  external int length;
}

class RawNativeIntersectionChangeEvent {
// Raw bytes represent the following fields.
//   NativeString *type;
//   int64_t bubbles;
//   int64_t cancelable;
//   int64_t timeStamp;
//   int64_t defaultPrevented;
//   void *target;
//   void *currentTarget;
//   double intersectionRatio;
  external Map<String, dynamic> bytes;

  external int length;
}

class RawNativeTouchEvent {
// Raw bytes represent the following fields.
//   NativeString *type;
//   int64_t bubbles;
//   int64_t cancelable;
//   int64_t timeStamp;
//   int64_t defaultPrevented;
//   void *target;
//   void *currentTarget;
//   double intersectionRatio;
//   NativeTouch **touches;
//   int64_t touchLength;
//   NativeTouch **targetTouches;
//   int64_t targetTouchLength;
//   NativeTouch **changedTouches;
//   int64_t changedTouchesLength;
//   int64_t altKey;
//   int64_t metaKey;
//   int64_t ctrlKey;
//   int64_t shiftKey;
  external Map<String, dynamic> bytes;

  external int length;
}

class NativeTouch {
  external int identifier;

  external NativeBindingObject target;

  external double clientX;

  external double clientY;

  external double screenX;

  external double screenY;

  external double pageX;

  external double pageY;

  external double radiusX;

  external double radiusY;

  external double rotationAngle;

  external double force;

  external double altitudeAngle;

  external double azimuthAngle;

  external int touchType;
}

class NativeBoundingClientRect {
  external double x;

  external double y;

  external double width;

  external double height;

  external double top;

  external double right;

  external double bottom;

  external double left;
}

typedef NativeDispatchEvent = int Function(
  int contextId,
  NativeBindingObject nativeBindingObject,
  String eventType,
  Event nativeEvent,
  int isCustomEvent,
);
typedef NativeInvokeBindingMethod = void Function(
  void nativePtr,
  dynamic returnValue,
  String method,
  int argc,
  dynamic argv,
);

class NativeBindingObject {
  external void instance;
  external NativeDispatchEvent dispatchEvent;
  // Shared method called by JS side.
  external Function invokeBindingMethod;
}

class NativeCanvasRenderingContext2D {
  external Function invokeBindingMethod;
}

class NativePerformanceEntry {
  external String name;

  external String entryType;

  external double startTime;

  external double duration;
}

class NativePerformanceEntryList {
  external String entries;

  external int length;
}
