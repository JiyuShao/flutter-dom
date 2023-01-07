/*
* Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
* Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
* Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
*/

import { addFlutterDomModuleListener, flutterDomInvokeModule, clearFlutterDomModuleListener, removeFlutterDomModuleListener } from './bridge';
import { methodChannel, triggerMethodCallHandler } from './method-channel';
import { dispatchConnectivityChangeEvent } from "./connection";

addFlutterDomModuleListener('Connection', (event, data) => dispatchConnectivityChangeEvent(event));
addFlutterDomModuleListener('MethodChannel', (event, data) => triggerMethodCallHandler(data[0], data[1]));

export const flutterDom = {
  methodChannel,
  invokeModule: flutterDomInvokeModule,
  addFlutterDomModuleListener: addFlutterDomModuleListener,
  clearFlutterDomModuleListener: clearFlutterDomModuleListener,
  removeFlutterDomModuleListener: removeFlutterDomModuleListener
};
