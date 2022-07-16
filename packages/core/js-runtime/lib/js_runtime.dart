library js_runtime;

export 'platform/js_runtime_main.dart'
    if (dart.library.js) 'platform/js_runtime_web.dart'
    if (dart.library.io) 'platform/js_runtime_native.dart';

export 'common/eval_result.dart';
export 'common/runtime.dart';
