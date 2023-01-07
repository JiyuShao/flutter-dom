/*
* Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
* Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
* Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
*/

import { flutterDom } from './flutter-dom';
import connection from './connection';

export const navigator = {
  connection,
  // UA is read-only.
  get userAgent() {
    return flutterDom.invokeModule('Navigator', 'getUserAgent');
  },
  get platform() {
    return flutterDom.invokeModule('Navigator', 'getPlatform');
  },
  get language() {
    return flutterDom.invokeModule('Navigator', 'getLanguage');
  },
  get languages() {
    return JSON.parse(flutterDom.invokeModule('Navigator', 'getLanguages'));
  },
  get appName() {
    return flutterDom.invokeModule('Navigator', 'getAppName');
  },
  get appVersion() {
    return flutterDom.invokeModule('Navigator', 'getAppVersion');
  },
  get hardwareConcurrency() {
    const logicalProcessors = flutterDom.invokeModule('Navigator', 'getHardwareConcurrency');
    return parseInt(logicalProcessors);
  },
  clipboard: {
    readText() {
      return new Promise((resolve, reject) => {
        flutterDom.invokeModule('Clipboard', 'readText', null, (e, data) => {
          if (e) {
            return reject(e);
          }
          resolve(data);
        });
      });
    },
    writeText(text: string) {
      return new Promise((resolve, reject) => {
        flutterDom.invokeModule('Clipboard', 'writeText', String(text), (e, data) => {
          if (e) {
            return reject(e);
          }
          resolve(data);
        });
      });
    }
  }
}
