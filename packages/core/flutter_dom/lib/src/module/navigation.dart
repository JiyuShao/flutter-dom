/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'module_manager.dart';

typedef FlutterDomNavigationDecisionHandler = Future<FlutterDomNavigationActionPolicy> Function(FlutterDomNavigationAction action);
typedef FlutterDomNavigationErrorHandler = void Function(Object error, Object stack);

enum FlutterDomNavigationActionPolicy {
  // allow flutter_dom to perform navigate.
  allow,

  // cancel flutter_dom default's navigate action.
  cancel
}

// https://www.w3.org/TR/navigation-timing-2/#sec-performance-navigation-types
enum FlutterDomNavigationType {
  // Navigation where the history handling behavior is set to "default"
  // or "replace" and the navigation was not initiated by a prerender hint.
  navigate,

  // Navigation where the history handling behavior is set to "reload".
  reload,

  // Navigation where the history handling behavior is set to "entry update".
  backForward,

  // Navigation initiated by a prerender hint.
  prerender
}

class NavigationModule extends BaseModule {
  @override
  String get name => 'Navigation';

  NavigationModule(ModuleManager? moduleManager) : super(moduleManager);

  @override
  void dispose() {}

  // Navigate flutter_dom page to target Url.
  Future<void> goTo(String targetUrl) async {
    String? sourceUrl = moduleManager!.controller.url;

    Uri targetUri = Uri.parse(targetUrl);
    Uri sourceUri = Uri.parse(sourceUrl);

    await moduleManager!.controller.view.handleNavigationAction(
        sourceUrl, targetUrl, targetUri == sourceUri ? FlutterDomNavigationType.reload : FlutterDomNavigationType.navigate);
  }

  @override
  String invoke(String method, params, callback) {
    if (method == 'goTo') {
      assert(params is String, 'URL must be string.');
      goTo(params);
    }

    return '';
  }
}

class FlutterDomNavigationAction {
  FlutterDomNavigationAction(this.source, this.target, this.navigationType);

  // The current source url.
  String? source;

  // The target source url.
  String target;

  // The navigation type.
  FlutterDomNavigationType navigationType;

  @override
  String toString() => 'FlutterDomNavigationType(source:$source, target:$target, navigationType:$navigationType)';
}

Future<FlutterDomNavigationActionPolicy> defaultDecisionHandler(FlutterDomNavigationAction action) async {
  return FlutterDomNavigationActionPolicy.allow;
}

class FlutterDomNavigationDelegate {
  // Called when an error occurs during navigation.
  FlutterDomNavigationErrorHandler? errorHandler;

  FlutterDomNavigationDecisionHandler _decisionHandler = defaultDecisionHandler;

  void setDecisionHandler(FlutterDomNavigationDecisionHandler handler) {
    _decisionHandler = handler;
  }

  Future<FlutterDomNavigationActionPolicy> dispatchDecisionHandler(FlutterDomNavigationAction action) async {
    return await _decisionHandler(action);
  }
}
