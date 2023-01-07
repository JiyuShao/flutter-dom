/*
* Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
* Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
* Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
*/

import { flutterDom } from './flutter-dom';

export const asyncStorage = {
  getItem(key: number | string) {
    return new Promise((resolve, reject) => {
      flutterDom.invokeModule('AsyncStorage', 'getItem', String(key), (e, data) => {
        if (e) return reject(e);
        resolve(data == null ? '' : data);
      });
    });
  },
  setItem(key: number | string, value: number | string) {
    return new Promise((resolve, reject) => {
      flutterDom.invokeModule('AsyncStorage', 'setItem', [String(key), String(value)], (e, data) => {
        if (e) return reject(e);
        resolve(data);
      });
    });
  },
  removeItem(key: number | string) {
    return new Promise((resolve, reject) => {
      flutterDom.invokeModule('AsyncStorage', 'removeItem', String(key), (e, data) => {
        if (e) return reject(e);
        resolve(data);
      });
    });
  },
  clear() {
    return new Promise((resolve, reject) => {
      flutterDom.invokeModule('AsyncStorage', 'clear', '', (e, data) => {
        if (e) return reject(e);
        resolve(data);
      });
    });
  },
  getAllKeys() {
    return new Promise((resolve, reject) => {
      flutterDom.invokeModule('AsyncStorage', 'getAllKeys', '', (e, data) => {
        if (e) return reject(e);
        resolve(data);
      });
    });
  },
  length(): Promise<number> {
    return new Promise((resolve, reject) => {
      flutterDom.invokeModule('AsyncStorage', 'length', '', (e, data) => {
        if (e) return reject(e);
        resolve(data);
      });
    });
  }
}
