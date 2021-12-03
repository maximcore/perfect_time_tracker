import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_time_tracker/app/home/models/job.dart';

void main() {
  group('fromJson', () {
    test('null data', () {
      final job = Job.fromMap(null, '');
      expect(job, null);
    });

    test('job with all properties', () {
      final job = Job.fromMap({
        'name': 'Sport',
        'ratePerHour': 50,
      }, 'abc');
      expect(job.name, 'Sport');
      expect(job.ratePerHour, 50);
      expect(job.id, 'abc');
      // or
      expect(job, Job(id: 'abc', name: 'Sport', ratePerHour: 50));
    });

    test('missing name', () {
      final job = Job.fromMap({
        'ratePerHour': 50,
      }, 'abc');
      expect(job, null);
    });
  });

  group('toJson', () {
    test('valid name, rPH', () {
      final job = Job(name: 'Music', ratePerHour: 30, id: 'abc');
      expect(job.toMap(), {
        'name': 'Music',
        'ratePerHour': 30,
      });
    });
  });
}
