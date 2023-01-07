/*
* Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
* Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
* Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
*/

import { URL } from './url';
import { flutterDom } from './flutter-dom';
import { flutterDomLocationReload } from './bridge';

// Lazy parse url.
let _url: URL;
export function getUrl() : URL {
  return _url ? _url : (_url = new URL(location.href));
}

export const location = {
  get href() {
    return flutterDom.invokeModule('Location', 'getHref');
  },
  set href(url: string) {
    flutterDom.invokeModule('Navigation', 'goTo', url);
  },
  get origin() {
    return getUrl().origin;
  },
  get protocol() {
    return getUrl().protocol;
  },
  get host() {
    return getUrl().host;
  },
  get hostname() {
    return getUrl().hostname;
  },
  get port() {
    return getUrl().port;
  },
  get pathname() {
    return getUrl().pathname;
  },
  get search() {
    return getUrl().search;
  },
  get hash() {
    return getUrl().hash;
  },

  get assign() {
    return (assignURL: string) => {
      flutterDom.invokeModule('Navigation', 'goTo', assignURL);
    };
  },
  get reload() {
    return flutterDomLocationReload.bind(this);
  },
  get replace() {
    return (replaceURL: string) => {
      flutterDom.invokeModule('Navigation', 'goTo', replaceURL);
    };
  },
  get toString() {
    return () => location.href;
  },
};
