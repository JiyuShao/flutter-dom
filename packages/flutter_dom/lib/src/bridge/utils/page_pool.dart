import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:js_runtime/common/logger.dart';
import 'package:js_runtime/js_runtime.dart';

class PagePool {
  bool _inited = false;
  bool _isDartHotRestart = false;
  final bool _isProfileMode = true;
  int _maxPoolSize = 0;
  int _poolIndex = 0;
  final Map<int, JsRuntime> _pageContextPool = {};
  String _bridgeJsCode = '';

  Future<String> _getPolyfillCode() async {
    String url = 'http://localhost:3000/FlutterDomBridge.js';
    Uri? uri = Uri.tryParse(url);

    final HttpClientRequest request = await HttpClient().getUrl(uri!);
    // Prepare request headers.
    request.headers.set('Accept', 'application/javascript');
    final HttpClientResponse response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('Unable to load asset: $url'),
        IntProperty('HTTP status code', response.statusCode),
      ]);
    }
    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    return utf8.decode(bytes);
  }

  void _disposeAllPages() {
    for (int i = 0; i <= _poolIndex && i < _maxPoolSize; i++) {
      disposePage(i);
    }
    _poolIndex = 0;
    _inited = false;
  }

  bool _checkPage(int contextId) {
    return _inited &&
        contextId < _maxPoolSize &&
        _pageContextPool[contextId] != null;
  }

  bool isDartHotRestart() {
    return _isDartHotRestart;
  }

  bool profileModeEnabled() {
    return _isProfileMode;
  }

  void initJSPagePool(int poolSize) {
    if (_inited) {
      _isDartHotRestart = true;
      _disposeAllPages();
      _isDartHotRestart = false;
    }

    _inited = true;
    _maxPoolSize = poolSize;
  }

  Future<int> allocateNewPage([int contextId = -1]) async {
    if (contextId == -1) {
      contextId = ++_poolIndex;
    }
    if (_checkPage(contextId)) {
      logger.d(
          'Can not Allocate page at index $contextId: page have already exist.');
      return contextId;
    }
    if (_bridgeJsCode.isEmpty) {
      _bridgeJsCode = await _getPolyfillCode();
    }
    JsRuntime jsRuntime = JsRuntime();
    _pageContextPool[contextId] = jsRuntime;
    await jsRuntime.waitUntilInited;
    jsRuntime.evaluate(_bridgeJsCode);
    return contextId;
  }

  void disposePage(int contextId) {
    if (!_checkPage(contextId)) {
      return;
    }
    _pageContextPool[contextId]?.dispose();
    _pageContextPool.remove(contextId);
    _poolIndex = 0;
    _inited = false;
  }

  void reloadJSContext(int contextId) {
    if (!_checkPage(contextId)) {
      return;
    }
    _pageContextPool[contextId]?.dispose();
    _pageContextPool.remove(contextId);
    allocateNewPage(contextId);
  }

  void evaluateScript(int contextId, String code, {String? url, int line = 0}) {
    if (!_checkPage(contextId)) {
      return;
    }
     _pageContextPool[contextId]?.evaluate(code);
  }
}
