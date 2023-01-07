/*
* Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
* Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
* Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
*/

declare const __flutter_dom_invoke_module__: (module: string, method: string, params?: any | null, fn?: (err: Error, data: any) => any) => any;
export const flutterDomInvokeModule = __flutter_dom_invoke_module__;

declare const __flutter_dom_add_module_listener__: (moduleName: string, fn: (event: Event, extra: any) => any) => void;
export const addFlutterDomModuleListener = __flutter_dom_add_module_listener__;

declare const __flutter_dom_clear_module_listener__: () => void;
export const clearFlutterDomModuleListener = __flutter_dom_clear_module_listener__;

declare const __flutter_dom_remove_module_listener__: (name: string) => void;
export const removeFlutterDomModuleListener = __flutter_dom_remove_module_listener__;

declare const __flutter_dom_location_reload__: () => void;
export const flutterDomLocationReload = __flutter_dom_location_reload__;

declare const __flutter_dom_print__: (log: string, level?: string) => void;
export const flutterDomPrint = __flutter_dom_print__;
