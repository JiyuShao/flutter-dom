/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'package:flutter_dom/dom.dart';
import 'package:flutter_dom/gesture.dart';
import 'package:flutter_dom/rendering.dart';

enum AppearEventType { none, appear, disappear }

const String EVENT_CLICK = 'click';
const String EVENT_INPUT = 'input';
const String EVENT_APPEAR = 'appear';
const String EVENT_DISAPPEAR = 'disappear';
const String EVENT_COLOR_SCHEME_CHANGE = 'colorschemechange';
const String EVENT_ERROR = 'error';
const String EVENT_MEDIA_ERROR = 'mediaerror';
const String EVENT_TOUCH_START = 'touchstart';
const String EVENT_TOUCH_MOVE = 'touchmove';
const String EVENT_TOUCH_END = 'touchend';
const String EVENT_TOUCH_CANCEL = 'touchcancel';
const String EVENT_MESSAGE = 'message';
const String EVENT_CLOSE = 'close';
const String EVENT_OPEN = 'open';
const String EVENT_INTERSECTION_CHANGE = 'intersectionchange';
const String EVENT_CANCEL = 'cancel';
const String EVENT_FINISH = 'finish';
const String EVENT_TRANSITION_RUN = 'transitionrun';
const String EVENT_TRANSITION_CANCEL = 'transitioncancel';
const String EVENT_TRANSITION_START = 'transitionstart';
const String EVENT_TRANSITION_END = 'transitionend';
const String EVENT_FOCUS = 'focus';
const String EVENT_BLUR = 'blur';
const String EVENT_LOAD = 'load';
const String EVENT_DOM_CONTENT_LOADED = 'DOMContentLoaded';
const String EVENT_UNLOAD = 'unload';
const String EVENT_CHANGE = 'change';
const String EVENT_CAN_PLAY = 'canplay';
const String EVENT_CAN_PLAY_THROUGH = 'canplaythrough';
const String EVENT_ENDED = 'ended';
const String EVENT_PAUSE = 'pause';
const String EVENT_POP_STATE = 'popstate';
const String EVENT_PLAY = 'play';
const String EVENT_SEEKED = 'seeked';
const String EVENT_SEEKING = 'seeking';
const String EVENT_VOLUME_CHANGE = 'volumechange';
const String EVENT_SCROLL = 'scroll';
const String EVENT_SWIPE = 'swipe';
const String EVENT_PAN = 'pan';
const String EVENT_SCALE = 'scale';
const String EVENT_LONG_PRESS = 'longpress';
const String EVENT_DOUBLE_CLICK = 'dblclick';
const String EVENT_DRAG = 'drag';
const String EVENT_RESIZE = 'resize';

const String EVENT_STATE_START = 'start';
const String EVENT_STATE_UPDATE = 'update';
const String EVENT_STATE_END = 'end';
const String EVENT_STATE_CANCEL = 'cancel';

mixin ElementEventMixin on ElementBase {
  AppearEventType _prevAppearState = AppearEventType.none;

  void clearEventResponder(RenderEventListenerMixin renderBox) {
    renderBox.getEventTarget = null;
    renderBox.getGestureDispather = null;
  }

  void ensureEventResponderBound() {
    // Must bind event responder on render box model whatever there is no event listener.
    RenderBoxModel? renderBox = renderBoxModel;
    if (renderBox != null) {
      // Make sure pointer responder bind.
      renderBox.getEventTarget = getEventTarget;
      renderBox.getGestureDispather = getGestureDispather;

      if (_hasIntersectionObserverEvent()) {
        renderBox.addIntersectionChangeListener(handleIntersectionChange);
        // Mark the compositing state for this render object as dirty
        // cause it will create new layer.
        renderBox.markNeedsCompositingBitsUpdate();
      } else {
        // Remove listener when no intersection related event
        renderBox.removeIntersectionChangeListener(handleIntersectionChange);
      }
    }
  }

  bool _hasIntersectionObserverEvent() {
    return hasEventListener(EVENT_APPEAR) ||
        hasEventListener(EVENT_DISAPPEAR) ||
        hasEventListener(EVENT_INTERSECTION_CHANGE);
  }

  @override
  void addEventListener(String eventType, EventHandler handler) {
    super.addEventListener(eventType, handler);
    RenderBoxModel? renderBox = renderBoxModel;
    if (renderBox != null) {
      ensureEventResponderBound();
    }
  }

  @override
  void removeEventListener(String eventType, EventHandler handler) {
    super.removeEventListener(eventType, handler);
    RenderBoxModel? renderBox = renderBoxModel;
    if (renderBox != null) {
      ensureEventResponderBound();
    }
  }

  EventTarget getEventTarget() {
    return this;
  }

  GestureDispatcher getGestureDispather() {
    return ownerDocument.controller.gestureDispatcher;
  }

  void handleAppear() {
    if (_prevAppearState == AppearEventType.appear) return;
    _prevAppearState = AppearEventType.appear;

    dispatchEvent(AppearEvent());
  }

  void handleDisappear() {
    if (_prevAppearState == AppearEventType.disappear) return;
    _prevAppearState = AppearEventType.disappear;

    dispatchEvent(DisappearEvent());
  }

  void handleIntersectionChange(IntersectionObserverEntry entry) {
    dispatchEvent(IntersectionChangeEvent(entry.intersectionRatio));
    if (entry.intersectionRatio > 0) {
      handleAppear();
    } else {
      handleDisappear();
    }
  }
}

// @TODO: inherit BindingObject to receive value from Cpp side.
/// reference: https://developer.mozilla.org/zh-CN/docs/Web/API/Event
class Event {
  String type;
  bool bubbles = false;
  bool cancelable = false;
  EventTarget? currentTarget;
  EventTarget? target;
  int timeStamp = DateTime.now().millisecondsSinceEpoch;
  bool defaultPrevented = false;
  bool _immediateBubble = true;
  bool propagationStopped = false;

  Event(this.type, [EventInit? init]) {
    init ??= EventInit();

    bubbles = init.bubbles;
    cancelable = init.cancelable;
  }

  void preventDefault() {
    if (cancelable) {
      defaultPrevented = true;
    }
  }

  bool canBubble() => _immediateBubble;
  void stopImmediatePropagation() {
    _immediateBubble = false;
  }

  void stopPropagation() {
    bubbles = false;
  }

  Map<String, dynamic> toJSON() {
    return {
      'type': type,
      'bubbles': bubbles,
      'cancelable': cancelable,
      'timeStamp': timeStamp,
      'defaultPrevented': defaultPrevented,
      'target': target,
      'currentTarget': currentTarget,
    };
  }

  @override
  String toString() {
    return 'Event($type)';
  }
}

class EventInit {
  final bool bubbles;
  final bool cancelable;

  EventInit({
    this.bubbles = false,
    this.cancelable = false,
  });
}

class PopStateEvent extends Event {
  final PopStateEventInit _popStateEventInit;
  PopStateEvent(this._popStateEventInit)
      : super('popstate', _popStateEventInit);
}

class PopStateEventInit extends EventInit {
  final dynamic state;
  PopStateEventInit(this.state);
}

/// reference: https://developer.mozilla.org/zh-CN/docs/Web/API/MouseEvent
class MouseEvent extends Event {
  final MouseEventInit _mouseEventInit;

  double get clientX => _mouseEventInit.clientX;
  double get clientY => _mouseEventInit.clientY;
  double get offsetX => _mouseEventInit.offsetX;
  double get offsetY => _mouseEventInit.offsetY;

  MouseEvent(String type, MouseEventInit mouseEventInit)
      : _mouseEventInit = mouseEventInit,
        super(type, mouseEventInit);
}

class MouseEventInit extends EventInit {
  final double clientX;
  final double clientY;
  final double offsetX;
  final double offsetY;

  MouseEventInit({
    bool bubbles = false,
    bool cancelable = false,
    this.clientX = 0.0,
    this.clientY = 0.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
  }) : super(bubbles: bubbles, cancelable: cancelable);
}

class GestureEventInit extends EventInit {
  final String state;
  final String direction;
  final double rotation;
  final double deltaX;
  final double deltaY;
  final double velocityX;
  final double velocityY;
  final double scale;

  GestureEventInit({
    bool bubbles = false,
    bool cancelable = false,
    this.state = '',
    this.direction = '',
    this.rotation = 0.0,
    this.deltaX = 0.0,
    this.deltaY = 0.0,
    this.velocityX = 0.0,
    this.velocityY = 0.0,
    this.scale = 0.0,
  }) : super(bubbles: bubbles, cancelable: cancelable);
}

/// reference: https://developer.mozilla.org/en-US/docs/Web/API/GestureEvent
class GestureEvent extends Event {
  final GestureEventInit _gestureEventInit;

  String get state => _gestureEventInit.state;
  String get direction => _gestureEventInit.direction;
  double get rotation => _gestureEventInit.rotation;
  double get deltaX => _gestureEventInit.deltaX;
  double get deltaY => _gestureEventInit.deltaY;
  double get velocityX => _gestureEventInit.velocityX;
  double get velocityY => _gestureEventInit.velocityY;
  double get scale => _gestureEventInit.scale;

  GestureEvent(String type, GestureEventInit gestureEventInit)
      : _gestureEventInit = gestureEventInit,
        super(type, gestureEventInit);
}

class CustomEventInit extends EventInit {
  final String detail;

  CustomEventInit(
      {bool bubbles = false, bool cancelable = false, required this.detail})
      : super(bubbles: bubbles, cancelable: cancelable);
}

/// reference: http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html#interface-CustomEvent
/// Attention: Detail now only can be a string.
class CustomEvent extends Event {
  final CustomEventInit _customEventInit;
  String get detail => _customEventInit.detail;

  CustomEvent(String type, CustomEventInit customEventInit)
      : _customEventInit = customEventInit,
        super(type, customEventInit);
}

// https://w3c.github.io/input-events/
class InputEvent extends Event {
  // A String containing the type of input that was made.
  // There are many possible values, such as insertText,
  // deleteContentBackward, insertFromPaste, and formatBold.
  final String inputType;
  final String data;

  InputEvent(
    this.data, {
    this.inputType = '',
  }) : super(EVENT_INPUT, EventInit(cancelable: true));
}

class AppearEvent extends Event {
  AppearEvent() : super(EVENT_APPEAR);
}

class DisappearEvent extends Event {
  DisappearEvent() : super(EVENT_DISAPPEAR);
}

class ColorSchemeChangeEvent extends Event {
  ColorSchemeChangeEvent(this.platformBrightness)
      : super(EVENT_COLOR_SCHEME_CHANGE);
  final String platformBrightness;
}

class MediaErrorCode {
  // The fetching of the associated resource was aborted by the user's request.
  static const double MEDIA_ERR_ABORTED = 1;
  // Some kind of network error occurred which prevented the media from being successfully fetched, despite having previously been available.
  static const double MEDIA_ERR_NETWORK = 2;
  // Despite having previously been determined to be usable, an error occurred while trying to decode the media resource, resulting in an error.
  static const double MEDIA_ERR_DECODE = 3;
  // The associated resource or media provider object (such as a MediaStream) has been found to be unsuitable.
  static const double MEDIA_ERR_SRC_NOT_SUPPORTED = 4;
}

class MediaError extends Event {
  /// A number which represents the general type of error that occurred, as follow
  final int code;

  /// a human-readable string which provides specific diagnostic information to help the reader understand the error condition which occurred;
  /// specifically, it isn't simply a summary of what the error code means, but actual diagnostic information to help in understanding what exactly went wrong.
  /// This text and its format is not defined by the specification and will vary from one user agent to another.
  /// If no diagnostics are available, or no explanation can be provided, this value is an empty string ("").
  final String message;

  MediaError(this.code, this.message) : super(EVENT_MEDIA_ERROR);
}

/// reference: https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent
class MessageEvent extends Event {
  /// The data sent by the message emitter.
  final dynamic data;

  /// A USVString representing the origin of the message emitter.
  final String origin;

  MessageEvent(this.data, {this.origin = ''}) : super(EVENT_MESSAGE);
}

/// reference: https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent/CloseEvent
class CloseEvent extends Event {
  /// An unsigned short containing the close code sent by the server
  final int code;

  /// Indicating the reason the server closed the connection.
  final String reason;

  /// Indicates whether or not the connection was cleanly closed
  final bool wasClean;

  CloseEvent(this.code, this.reason, this.wasClean) : super(EVENT_CLOSE);
}

class IntersectionChangeEvent extends Event {
  IntersectionChangeEvent(this.intersectionRatio)
      : super(EVENT_INTERSECTION_CHANGE);
  final double intersectionRatio;
}

/// reference: https://w3c.github.io/touch-events/#touchevent-interface
class TouchEvent extends Event {
  TouchEvent(String type)
      : super(type, EventInit(bubbles: true, cancelable: true));

  TouchList touches = TouchList();
  TouchList targetTouches = TouchList();
  TouchList changedTouches = TouchList();

  bool altKey = false;
  bool metaKey = false;
  bool ctrlKey = false;
  bool shiftKey = false;
}

enum TouchType {
  direct,
  stylus,
}

/// reference: https://w3c.github.io/touch-events/#dom-touch
class Touch {
  final int identifier;
  final EventTarget target;
  final double clientX;
  final double clientY;
  final double screenX;
  final double screenY;
  final double pageX;
  final double pageY;
  final double radiusX;
  final double radiusY;
  final double rotationAngle;
  final double force;
  final double altitudeAngle;
  final double azimuthAngle;
  final TouchType touchType;

  const Touch({
    required this.identifier,
    required this.target,
    this.clientX = 0,
    this.clientY = 0,
    this.screenX = 0,
    this.screenY = 0,
    this.pageX = 0,
    this.pageY = 0,
    this.radiusX = 0,
    this.radiusY = 0,
    this.rotationAngle = 0,
    this.force = 0,
    this.altitudeAngle = 0,
    this.azimuthAngle = 0,
    this.touchType = TouchType.direct,
  });
}

/// reference: https://w3c.github.io/touch-events/#touchlist-interface
class TouchList {
  final List<Touch> _items = [];
  int get length => _items.length;

  Touch item(int index) {
    return _items[index];
  }

  Touch operator [](int index) {
    return _items[index];
  }

  // https://github.com/WebKit/WebKit/blob/main/Source/WebCore/dom/TouchList.h#L54
  void append(Touch touch) {
    _items.add(touch);
  }
}
