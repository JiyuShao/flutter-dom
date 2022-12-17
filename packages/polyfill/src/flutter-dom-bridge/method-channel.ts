/*
* Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
* Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
* Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
*/

import { flutterDomInvokeModule } from './bridge';

type MethodCallHandler = (args: any[]) => void;

let methodCallHandlers: {[key: string]: MethodCallHandler} = {};

// Like flutter platform channels
export const methodChannel = {
  addMethodCallHandler(method: string, handler: MethodCallHandler) {
    if (typeof handler !== 'function') {
      throw new Error('webf.addMethodCallHandler: handler should be an function.');
    }
    methodCallHandlers[method] = handler;
  },
  removeMethodCallHandler(method: string) {
    delete methodCallHandlers[method];
  },
  clearMethodCallHandler() {
    methodCallHandlers = {};
  },
  invokeMethod(method: string, ...args: any[]): Promise<string> {
    return new Promise((resolve, reject) => {
      flutterDomInvokeModule('MethodChannel', 'invokeMethod', [method, args], (e, data) => {
        if (e) return reject(e);
        resolve(data);
      });
    });
  },
};

export function triggerMethodCallHandler(method: string, args: any[]) {
  if (!methodCallHandlers.hasOwnProperty(method)) {
    return null;
  }

  return methodCallHandlers[method](args);
}
