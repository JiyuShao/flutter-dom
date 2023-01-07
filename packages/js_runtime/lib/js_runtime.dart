library js_runtime;

export 'platform/default/index.dart'
    if (dart.library.js) 'platform/web/index.dart'
    if (dart.library.io) 'platform/native/index.dart';
