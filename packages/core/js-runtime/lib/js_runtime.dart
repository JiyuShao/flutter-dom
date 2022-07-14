library js_runtime;

export 'js_runtime_main.dart'
    if (dart.library.js) 'js_runtime_web.dart'
    if (dart.library.io) 'js_runtime_native.dart';
