// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;

html.ScriptElement _createScriptTag(String url) {
  final html.ScriptElement script = html.ScriptElement()
    ..type = "text/javascript"
    ..charset = "utf-8"
    ..src = url;
  return script;
}

// 加载 JS
Future<void> loadScript(String url) {
  final List<Future<void>> loading = <Future<void>>[];
  final head = html.querySelector('head');
  if (!isLoaded(url)) {
    final scriptTag = _createScriptTag(url);
    head?.children.add(scriptTag);
    loading.add(scriptTag.onLoad.first);
  }
  return Future.wait(loading);
}

// 判断 JS 是否已经加载
bool isLoaded(String url) {
  final head = html.querySelector('head');
  for (var element in head!.children) {
    if (element is html.ScriptElement) {
      if (element.src.endsWith(url)) {
        return true;
      }
    }
  }
  return false;
}
