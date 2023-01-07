/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */

class UriParser {
  Uri resolve(Uri base, Uri relative) {
    final Uri uri = base.resolveUri(relative);
    assert(uri.hasScheme);
    return uri;
  }
}
