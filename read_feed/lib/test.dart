// Copyright (c) 2015, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

Future<List> sumStream(Stream<int> stream) async {
  var sum = [];
  await for (var value in stream) {
    sum.add(value);
  }
  return sum;
}

Stream<int> countStream(int to) async* {
  for (int i = 1; i <= to; i++) {
    yield i;
  }
}

main() async {
  var stream = countStream(20);
  var sum = await sumStream(stream);
  print(sum); // 55
}
