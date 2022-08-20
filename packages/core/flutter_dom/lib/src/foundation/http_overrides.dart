/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'dart:io';

import 'package:flutter_dom/flutter_dom.dart';

// TODO: Don't use header to mark context.
const String HttpHeaderContext = 'x-context';

class FlutterDomHttpOverrides extends HttpOverrides {
  static FlutterDomHttpOverrides? _instance;

  FlutterDomHttpOverrides._();

  factory FlutterDomHttpOverrides.instance() {
    _instance ??= FlutterDomHttpOverrides._();
    return _instance!;
  }

  static int? getContextHeader(HttpHeaders headers) {
    String? intVal = headers.value(HttpHeaderContext);
    if (intVal == null) {
      return null;
    }
    return int.tryParse(intVal);
  }

  static void setContextHeader(HttpHeaders headers, int contextId) {
    headers.set(HttpHeaderContext, contextId.toString());
  }

  final HttpOverrides? parentHttpOverrides = HttpOverrides.current;
  final Map<int, HttpClientInterceptor> _contextIdToHttpClientInterceptorMap = <int, HttpClientInterceptor>{};

  void registerFlutterDomContext(int contextId, HttpClientInterceptor httpClientInterceptor) {
    _contextIdToHttpClientInterceptorMap[contextId] = httpClientInterceptor;
  }

  bool unregisterFlutterDomContext(int contextId) {
    // Returns true if [value] was in the map, false otherwise.
    return _contextIdToHttpClientInterceptorMap.remove(contextId) != null;
  }

  bool hasInterceptor(int contextId) {
    return _contextIdToHttpClientInterceptorMap.containsKey(contextId);
  }

  HttpClientInterceptor getInterceptor(int contextId) {
    return _contextIdToHttpClientInterceptorMap[contextId]!;
  }

  void clearInterceptors() {
    _contextIdToHttpClientInterceptorMap.clear();
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    HttpClient nativeHttpClient;
    if (parentHttpOverrides != null) {
      nativeHttpClient = parentHttpOverrides!.createHttpClient(context);
    } else {
      nativeHttpClient = super.createHttpClient(context);
    }

    return ProxyHttpClient(nativeHttpClient, this);
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? environment) {
    if (parentHttpOverrides != null) {
      return parentHttpOverrides!.findProxyFromEnvironment(url, environment);
    } else {
      return super.findProxyFromEnvironment(url, environment);
    }
  }
}

FlutterDomHttpOverrides setupHttpOverrides(HttpClientInterceptor? httpClientInterceptor, {required int contextId}) {
  final FlutterDomHttpOverrides httpOverrides = FlutterDomHttpOverrides.instance();

  if (httpClientInterceptor != null) {
    httpOverrides.registerFlutterDomContext(contextId, httpClientInterceptor);
  }

  HttpOverrides.global = httpOverrides;
  return httpOverrides;
}

// Returns the origin of the URI in the form scheme://host:port
String getOrigin(Uri uri) {
  if (uri.isScheme('http') || uri.isScheme('https')) {
    return uri.origin;
  } else {
    return uri.path;
  }
}

// @TODO: Remove controller dependency.
Uri getEntrypointUri(int? contextId) {
  FlutterDomController? controller = FlutterDomController.getControllerOfJSContextId(contextId);
  String url = controller?.url ?? '';
  return Uri.tryParse(url) ?? FlutterDomController.fallbackBundleUri(contextId ?? 0);
}
