/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dom/dom.dart';
import 'package:flutter_dom/flutter_dom.dart';
import 'package:js_runtime/js_runtime.dart';

// Register getFlutterDomInfo
class FlutterDomInfo {
  final NativeFlutterDomInfo _nativeFlutterDomInfo;

  FlutterDomInfo(NativeFlutterDomInfo info) : _nativeFlutterDomInfo = info;

  String get appName {
    if (_nativeFlutterDomInfo.appName == null) return '';
    return _nativeFlutterDomInfo.appName!;
  }

  String get appVersion {
    if (_nativeFlutterDomInfo.appVersion == null) return '';
    return _nativeFlutterDomInfo.appVersion!;
  }

  String get appRevision {
    if (_nativeFlutterDomInfo.appRevision == null) return '';
    return _nativeFlutterDomInfo.appRevision!;
  }

  String get systemName {
    if (_nativeFlutterDomInfo.systemName == null) return '';
    return _nativeFlutterDomInfo.systemName!;
  }
}

// Register getFlutterDomInfo
NativeFlutterDomInfo _getFlutterDomInfo() {
  // TODO: 待实现
  return null as dynamic;
}

final FlutterDomInfo _cachedInfo = FlutterDomInfo(_getFlutterDomInfo());
FlutterDomInfo getFlutterDomInfo() {
  return _cachedInfo;
}

// Register invokeModuleEvent
void _invokeModuleEvent(int contextId, String moduleName, String eventType,
    String event, String extra) {
  // TODO: 待实现
}
void invokeModuleEvent(
    int contextId, String moduleName, Event? event, String extra) {
  if (FlutterDomController.getControllerOfJSContextId(contextId) == null) {
    return;
  }
  if (event == null) {
    return;
  }
  _invokeModuleEvent(
    contextId,
    moduleName,
    event.type,
    jsonEncode(event),
    extra,
  );
}

// Register emitUIEvent
void emitUIEvent(
    int contextId, NativeBindingObject nativeBindingObject, Event event) {
  if (FlutterDomController.getControllerOfJSContextId(contextId) == null) {
    return;
  }
  bool isCustomEvent = event is CustomEvent;
  // @TODO: Make Event inherit BindingObject to pass value from bridge to dart.
  int propagationStopped = nativeBindingObject.dispatchEvent(
      contextId, nativeBindingObject, event.type, event, isCustomEvent ? 1 : 0);
  event.propagationStopped = propagationStopped == 1 ? true : false;
}

// Register emitModuleEvent
void emitModuleEvent(
    int contextId, String moduleName, Event? event, String extra) {
  invokeModuleEvent(contextId, moduleName, event, extra);
}

// Register createScreen
int _createScreen(double width, double height) {
  // TODO: 待实现
  return null as dynamic;
}

int createScreen(double width, double height) {
  return _createScreen(width, height);
}

// Register evaluateScripts
Future<void> _evaluateScripts(
    int contextId, String code, String url, int line) async {
  JsRuntime jsRuntime = JsRuntime();
  await jsRuntime.waitUntilInited;
  jsRuntime.evaluate(code);
  return null as dynamic;
}

int _anonymousScriptEvaluationId = 0;
void evaluateScripts(int contextId, String code, {String? url, int line = 0}) {
  if (FlutterDomController.getControllerOfJSContextId(contextId) == null) {
    return;
  }
  // Assign `vm://$id` for no url (anonymous scripts).
  if (url == null) {
    url = 'vm://$_anonymousScriptEvaluationId';
    _anonymousScriptEvaluationId++;
  }
  try {
    _evaluateScripts(contextId, code, url, line);
  } catch (e, stack) {
    print('$e\n$stack');
  }
}

// Register evaluateQuickjsByteCode
void _evaluateQuickjsByteCode(int contextId, List bytes, int length) {
  // TODO: 待实现
  return null as dynamic;
}

void evaluateQuickjsByteCode(int contextId, List bytes) {
  if (FlutterDomController.getControllerOfJSContextId(contextId) == null) {
    return;
  }
  _evaluateQuickjsByteCode(contextId, bytes, bytes.length);
}

// Register parseHTML
void _parseHTML(int contextId, String code, int length) {
  // TODO: 待实现
  return null as dynamic;
}

void parseHTML(int contextId, String code) {
  if (FlutterDomController.getControllerOfJSContextId(contextId) == null) {
    return;
  }
  try {
    _parseHTML(contextId, code, code.length);
  } catch (e, stack) {
    print('$e\n$stack');
  }
}

// Register initJSPagePool
void _initJSPagePool(int contextId) {
  // TODO: 待实现
  return null as dynamic;
}

void initJSPagePool(int poolSize) {
  _initJSPagePool(poolSize);
}

// Register disposePage
void _disposePage(int contextId) {
  // TODO: 待实现
  return null as dynamic;
}

void disposePage(int contextId) {
  _disposePage(contextId);
}

// Register allocateNewPage
int _allocateNewPage(int contextId) {
  // TODO: 待实现
  return null as dynamic;
}

int allocateNewPage([int targetContextId = -1]) {
  return _allocateNewPage(targetContextId);
}

// Register registerPluginByteCode

void _registerPluginByteCode(List bytes, int length, String name) {
  // TODO: 待实现
  return null as dynamic;
}

void registerPluginByteCode(List bytes, String name) {
  _registerPluginByteCode(bytes, bytes.length, name);
}

// Register profileModeEnabled

int _profileModeEnabled() {
  // TODO: 待实现
  return null as dynamic;
}

const _CODE_ENABLED = 1;
bool profileModeEnabled() {
  return _profileModeEnabled() == _CODE_ENABLED;
}

// Register reloadJSContext
void _reloadJSContext(int contextId) {
  // TODO: 待实现
  return null as dynamic;
}

Future<void> reloadJSContext(int contextId) async {
  Completer completer = Completer<void>();
  Future.microtask(() {
    _reloadJSContext(contextId);
    completer.complete();
  });
  return completer.future;
}

// Register flushUICommandCallback
void _flushUICommandCallback() {
  // TODO: 待实现
  return null as dynamic;
}

void flushUICommandCallback() {
  _flushUICommandCallback();
}

// Register dispatchUITask
void _dispatchUITask(int contextId, Function callback) {
  // TODO: 待实现
  return null as dynamic;
}

void dispatchUITask(int contextId, Function callback) {
  _dispatchUITask(contextId, callback);
}

// Register readUICommand
enum UICommandType {
  createElement,
  createTextNode,
  createComment,
  disposeEventTarget,
  addEvent,
  removeNode,
  insertAdjacentNode,
  setStyle,
  setAttribute,
  removeAttribute,
  cloneNode,
  removeEvent,
  createDocumentFragment,
}

class UICommand {
  late final UICommandType type;
  late final int id;
  late final List<String> args;

  @override
  String toString() {
    return 'UICommand(type: $type, id: $id, args: $args)';
  }
}

final bool isEnabledLog =
    kDebugMode && Platform.environment['ENABLE_FLUTTER_DOM_JS_LOG'] == 'true';

List<UICommand> readUICommand(int contextId) {
  List<UICommand> commands = [];
  for (var command in commands) {
    if (isEnabledLog) {
      String printMsg = '${command.type}, id: ${command.id}';
      for (int i = 0; i < command.args.length; i++) {
        printMsg += ' args[$i]: ${command.args[i]}';
      }
      print(printMsg);
    }
  }
  clearUICommand(contextId);

  return commands;
}

// Register clearUICommand
void _clearUICommandItems(int contextId) {
  // TODO: 待实现
  return null as dynamic;
}

void clearUICommand(int contextId) {
  _clearUICommandItems(contextId);
}

// Register flushUICommand
void flushUICommand() {
  Map<int, FlutterDomController?> controllerMap =
      FlutterDomController.getControllerMap();
  for (FlutterDomController? controller in controllerMap.values) {
    if (controller == null) continue;
    List<UICommand> commands = readUICommand(controller.view.contextId);
    int commandLength = commands.length;
    if (commandLength == 0) {
      continue;
    }

    if (kProfileMode) {
      PerformanceTiming.instance().mark(PERF_FLUSH_UI_COMMAND_START);
    }

    SchedulerBinding.instance.scheduleFrame();

    if (kProfileMode) {
      PerformanceTiming.instance().mark(PERF_FLUSH_UI_COMMAND_END);
    }

    Map<int, bool> pendingStylePropertiesTargets = {};

    // For new ui commands, we needs to tell engine to update frames.
    for (int i = 0; i < commandLength; i++) {
      UICommand command = commands[i];
      UICommandType commandType = command.type;
      int id = command.id;

      try {
        switch (commandType) {
          case UICommandType.createElement:
            controller.view.createElement(id, command.args[0]);
            break;
          case UICommandType.createTextNode:
            controller.view.createTextNode(id, command.args[0]);
            break;
          case UICommandType.createComment:
            controller.view.createComment(id);
            break;
          case UICommandType.disposeEventTarget:
            controller.view.disposeEventTarget(id);
            break;
          case UICommandType.addEvent:
            controller.view.addEvent(id, command.args[0]);
            break;
          case UICommandType.removeEvent:
            controller.view.removeEvent(id, command.args[0]);
            break;
          case UICommandType.insertAdjacentNode:
            int childId = int.parse(command.args[0]);
            String position = command.args[1];
            controller.view.insertAdjacentNode(id, position, childId);
            break;
          case UICommandType.removeNode:
            controller.view.removeNode(id);
            break;
          case UICommandType.cloneNode:
            int newId = int.parse(command.args[0]);
            controller.view.cloneNode(id, newId);
            break;
          case UICommandType.setStyle:
            String key = command.args[0];
            String value = command.args[1];
            controller.view.setInlineStyle(id, key, value);
            pendingStylePropertiesTargets[id] = true;
            break;
          case UICommandType.setAttribute:
            String key = command.args[0];
            String value = command.args[1];
            controller.view.setAttribute(id, key, value);
            break;
          case UICommandType.removeAttribute:
            String key = command.args[0];
            controller.view.removeAttribute(id, key);
            break;
          case UICommandType.createDocumentFragment:
            controller.view.createDocumentFragment(id);
            break;
          default:
            break;
        }
      } catch (e, stack) {
        print('$e\n$stack');
      }
    }

    // For pending style properties, we needs to flush to render style.
    for (int id in pendingStylePropertiesTargets.keys) {
      try {
        controller.view.flushPendingStyleProperties(id);
      } catch (e, stack) {
        print('$e\n$stack');
      }
    }
    pendingStylePropertiesTargets.clear();
  }
}
