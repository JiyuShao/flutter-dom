/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */

import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter_dom/dom.dart';
import 'package:flutter_dom/flutter_dom.dart';

typedef ConnectedCallback = void Function();

const String BUNDLE_URL = 'FLUTTER_DOM_BUNDLE_URL';
const String BUNDLE_PATH = 'FLUTTER_DOM_BUNDLE_PATH';
const String ENABLE_DEBUG = 'FLUTTER_DOM_ENABLE_DEBUG';
const String ENABLE_PERFORMANCE_OVERLAY = 'FLUTTER_DOM_ENABLE_PERFORMANCE_OVERLAY';
const _white = Color(0xFFFFFFFF);

String? getBundleURLFromEnv() {
  return Platform.environment[BUNDLE_URL];
}

String? getBundlePathFromEnv() {
  return Platform.environment[BUNDLE_PATH];
}

void launch(
    {FlutterDomBundle? bundle,
    bool? debugEnableInspector,
    Color background = _white,
    DevToolsService? devToolsService,
    HttpClientInterceptor? httpClientInterceptor,
    bool? showPerformanceOverlay = false}) async {
  // Bootstrap binding.
  ElementsFlutterBinding.ensureInitialized().scheduleWarmUpFrame();

  VoidCallback? _ordinaryOnMetricsChanged = window.onMetricsChanged;

  Future<void> _initFlutterDomApp() async {
    FlutterDomNativeChannel channel = FlutterDomNativeChannel();

    if (bundle == null) {
      String? backendEntrypointUrl = getBundleURLFromEnv() ?? getBundlePathFromEnv();
      backendEntrypointUrl ??= await channel.getUrl();
      if (backendEntrypointUrl != null) {
        bundle = FlutterDomBundle.fromUrl(backendEntrypointUrl);
      }
    }

    FlutterDomController controller = FlutterDomController(
      null,
      window.physicalSize.width / window.devicePixelRatio,
      window.physicalSize.height / window.devicePixelRatio,
      background: background,
      showPerformanceOverlay: showPerformanceOverlay ?? Platform.environment[ENABLE_PERFORMANCE_OVERLAY] != null,
      methodChannel: channel,
      entrypoint: bundle,
      devToolsService: devToolsService,
      httpClientInterceptor: httpClientInterceptor,
      autoExecuteEntrypoint: false,
    );
    await controller.waitUntilInited;

    controller.view.attachTo(RendererBinding.instance.renderView);

    await controller.executeEntrypoint();
  }

  // window.physicalSize are Size.zero when app first loaded. This only happened on Android and iOS physical devices with release build.
  // We should wait for onMetricsChanged when window.physicalSize get updated from Flutter Engine.
  if (window.physicalSize == Size.zero) {
    window.onMetricsChanged = () async {
      if (window.physicalSize == Size.zero) {
        return;
      }

      await _initFlutterDomApp();

      // Should proxy to ordinary window.onMetricsChanged callbacks.
      if (_ordinaryOnMetricsChanged != null) {
        _ordinaryOnMetricsChanged();
        // Recover ordinary callback to window.onMetricsChanged
        window.onMetricsChanged = _ordinaryOnMetricsChanged;
      }
    };
  } else {
    await _initFlutterDomApp();
  }
}
