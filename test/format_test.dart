import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:perfect_time_tracker/app/home/job_entries/format.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });
    test('zero', () {
      expect(Format.hours(0), '0h');
    });
    test('negative', () {
      expect(Format.hours(-5), '0h');
    });
    test('decimal', () {
      expect(Format.hours(2.5), '2.5h');
    });
  });

  group('date', () {
    test('2021-01-01', () {
      expect(
        Format.date(DateTime(2021, 1, 1)),
        'Jan 1, 2021',
      );
    });
  });
}
