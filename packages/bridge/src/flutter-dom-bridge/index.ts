/*
* Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
* Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
* Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
*/

import './dom';
import { console } from './console';
import { fetch, Request, Response, Headers } from './fetch';
import { matchMedia } from './match-media';
import { location } from './location';
import { history } from './history';
import { navigator } from './navigator';
import { XMLHttpRequest } from './xhr';
import { asyncStorage } from './async-storage';
import { URLSearchParams } from './url-search-params';
import { URL } from './url';
import { flutterDom } from './flutter-dom';

defineGlobalProperty('console', console);
defineGlobalProperty('Request', Request);
defineGlobalProperty('Response', Response);
defineGlobalProperty('Headers', Headers);
defineGlobalProperty('fetch', fetch);
defineGlobalProperty('matchMedia', matchMedia);
defineGlobalProperty('location', location);
defineGlobalProperty('history', history);
defineGlobalProperty('navigator', navigator);
defineGlobalProperty('XMLHttpRequest', XMLHttpRequest);
defineGlobalProperty('asyncStorage', asyncStorage);
defineGlobalProperty('URLSearchParams', URLSearchParams);
defineGlobalProperty('URL', URL);
defineGlobalProperty('flutterDom', flutterDom);

function defineGlobalProperty(key: string, value: any, isEnumerable: boolean = true) {
  Object.defineProperty(globalThis, key, {
    value: value,
    enumerable: isEnumerable,
    writable: true,
    configurable: true
  });
}
