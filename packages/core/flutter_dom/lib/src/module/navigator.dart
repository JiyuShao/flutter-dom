/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter_dom/bridge.dart';
import 'package:flutter_dom/src/module/module_manager.dart';

String? _customUserAgent;

class NavigatorModule extends BaseModule {
  @override
  String get name => 'Navigator';

  NavigatorModule(ModuleManager? moduleManager) : super(moduleManager);

  @override
  void dispose() {}

  @override
  String invoke(String method, params, callback) {
    switch (method) {
      case 'getUserAgent':
        return getUserAgent();
      case 'getPlatform':
        return getPlaftorm();
      case 'getLanguage':
        return getLanguage();
      case 'getLanguages':
        return getLanguages();
      case 'getHardwareConcurrency':
        return getHardwareConcurrency();
      case 'getAppName':
        return getAppName();
      case 'getAppVersion':
        return getAppVersion();
      default:
        return '';
    }
  }

  static String getPlaftorm() {
    return Platform.operatingSystem;
  }

  static String getLanguage() {
    return PlatformDispatcher.instance.locale.toLanguageTag();
  }

  static String getLanguages() {
    // Stringify the list of languages to JSON format.
    return '[' + PlatformDispatcher.instance.locales.map(((locale) => '"${locale.toLanguageTag()}"')).join(',') + ']';
  }

  static String getHardwareConcurrency() {
    return Platform.numberOfProcessors.toString();
  }

  static String getAppName() {
    FlutterDomInfo info = getFlutterDomInfo();
    return info.appName;
  }

  static String getAppVersion() {
    FlutterDomInfo info = getFlutterDomInfo();
    return info.appVersion;
  }

  static String getUserAgent() {
    if (_customUserAgent != null) {
      return _customUserAgent!;
    }
    return getDefaultUserAgent();
  }

  static void setCustomUserAgent(String userAgent) {
    _customUserAgent = userAgent;
  }

  static String getDefaultUserAgent() {
    FlutterDomInfo info = getFlutterDomInfo();
    String appName = info.appName;
    String appVersion = info.appVersion;
    String appRevision = info.appRevision;
    String systemName = info.systemName;
    return '$appName/$appVersion ($systemName; $appName/$appRevision)';
  }
}
