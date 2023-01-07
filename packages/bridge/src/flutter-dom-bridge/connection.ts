/*
* Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
* Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
* Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
*/

import { flutterDomInvokeModule } from './bridge';

let connectivityChangeListener: (data: Object) => any;

export function dispatchConnectivityChangeEvent(event: any) {
  if (connectivityChangeListener) {
    connectivityChangeListener(event);
  }
}

export default {
  getConnectivity() {
    return new Promise((resolve, reject) => {
      flutterDomInvokeModule('Connection', 'getConnectivity', null, (e, data) => {
        if (e) return reject(e);
        resolve(data);
      });
    });
  },
  set onchange(listener: (data: Object) => any) {
    if (typeof listener === 'function') {
      connectivityChangeListener = listener;
      // TODO: should remove old listener when onchange reset with a null listener
      flutterDomInvokeModule('Connection', 'onConnectivityChanged');
    }
  }
}
