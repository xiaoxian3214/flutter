// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRestorationManager extends TestRestorationManager {
  bool get updateScheduled => _updateScheduled;
  bool _updateScheduled = false;

  final List<RestorationBucket> _buckets = <RestorationBucket>[];

  @override
  void scheduleSerializationFor(RestorationBucket bucket) {
    _updateScheduled = true;
    _buckets.add(bucket);
  }

  @override
  bool unscheduleSerializationFor(RestorationBucket bucket) {
    _updateScheduled = true;
    return _buckets.remove(bucket);
  }

  void doSerialization() {
    _updateScheduled = false;
    for (final RestorationBucket bucket in _buckets) {
      bucket.finalize();
    }
    _buckets.clear();
  }

  @override
  void restoreFrom(TestRestorationData data) {
    // Ignore in mock.
  }

  int rootBucketAccessed = 0;

  @override
  Future<RestorationBucket> get rootBucket {
    rootBucketAccessed++;
    return _rootBucket;
  }
  Future<RestorationBucket> _rootBucket;
  set rootBucket(Future<RestorationBucket> value) {
    _rootBucket = value;
    notifyListeners();
  }


  @override
  Future<void> sendToEngine(Uint8List encodedData) {
    throw UnimplementedError('unimplemented in mock');
  }

  @override
  String toString() => 'MockManager';
}

const String childrenMapKey = 'c';
const String valuesMapKey = 'v';
