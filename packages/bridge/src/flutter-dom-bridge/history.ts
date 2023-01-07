/*
* Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
* Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
* Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
*/

import { flutterDom } from './flutter-dom';

class History {
  constructor() {
  }

  get length() {
    return Number(flutterDom.invokeModule('History', 'length'));
  }

  get state() {
    return JSON.parse(flutterDom.invokeModule('History', 'state'));
  }

  back() {
     flutterDom.invokeModule('History', 'back');
  }

  forward() {
    flutterDom.invokeModule('History', 'forward');
  }

  go(delta?: number) {
    flutterDom.invokeModule('History', 'go', delta ? Number(delta) : null);
  }

  pushState(state: any, title: string, url?: string) {
    if (arguments.length < 2) {
      throw TypeError("Failed to execute 'pushState' on 'History': 2 arguments required, but only " + arguments.length + " present");
    }

    flutterDom.invokeModule('History', 'pushState', [state, title, url]);
  }

  replaceState(state: any, title: string, url?: string) {
    if (arguments.length < 2) {
      throw TypeError("Failed to execute 'pushState' on 'History': 2 arguments required, but only " + arguments.length + " present");
    }

    flutterDom.invokeModule('History', 'replaceState', [state, title, url]);
  }
}

export const history = new History();
