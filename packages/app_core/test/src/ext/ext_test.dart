import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app_core/app_core.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id');
  });

  group('StringExt Tests', () {
    test('Capitalize works as expected', () {
      expect('hello'.capitalize, 'Hello');
      expect('HELLO'.capitalize, 'Hello');
      expect('hello world'.capitalize, 'Hello world');
      expect(''.capitalize, '');
    });
  });

  group('NumExt Tests', () {
    test('currencyFormat formats correctly', () {
      expect(100000.currencyFormat(symbol: "Rp. "), "Rp. 100.000");
    });
  });

  group('DateExt Tests', () {
    final date = DateTime.parse("2025-02-19 20:00:00.000Z");

    test('Local date formatting', () {
      final formatted = date.localDateStringForm(pattern: "dd/MM/yyyy");
      expect(formatted.contains('/'), true);
    });

    test('UTC date formatting', () {
      final utcFormatted = date.utcDateTimeStringForm(pattern: "yyyy-MM-dd");
      expect(utcFormatted, "2025-02-19");
    });
  });

  group('IterableExtension Tests', () {
    final list = [1, 2, 3, 4, 5];

    test('getAtOrNull and lastIndex', () {
      expect(list.lastIndex, 4);
      expect(list.isLastIndex(4), true);
      expect(list.getAtOrNull(2), 3);
      expect(list.getAtOrNull(10), isNull);
    });

    test('mapIndexed', () {
      final mapped = list.mapIndexed((index, item) => '$index:$item').toList();
      expect(mapped.first, '0:1');
    });

    test('firstWhereOrNull', () {
      final found = list.firstWhereOrNull((index, item) => item > 3);
      expect(found, 4);

      final notFound = list.firstWhereOrNull((index, item) => item > 10);
      expect(notFound, isNull);
    });
  });

  group('MapExtension Tests', () {
    final map = {'a': 1, 'b': 2};

    test('getOrNull and getAndMapOrNull', () {
      expect(map.getOrNull('a'), 1);
      expect(map.getOrNull('z'), isNull);
      expect(map.getAndMapOrNull('a', (v) => v * 10), 10);
      expect(map.getAndMapOrNull('z', (v) => v * 10), isNull);
    });
  });

  group('DynamicExt Tests', () {
    test('let and run', () {
      const value = 5;
      final doubled = value.let((it) => it * 2);
      expect(doubled, 10);

      var executed = false;
      value.run((it) => executed = true);
      expect(executed, true);
    });
  });

  group('TimeDifferenceUtils Tests', () {
    test('Just now calculation', () {
      final now = DateTime.now();
      expect(TimeDifferenceUtils.getTimeDiff(now), 'Just now');
      expect(
        TimeDifferenceUtils.getTimeDiff(now, labels: TimeDifferenceLabels.id),
        'Baru saja',
      );
    });
  });
}
