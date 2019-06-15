import 'package:test/test.dart';
import 'package:aviation_wx/src/utils/wx_options.dart';
import 'package:aviation_wx/src/utils/wx_text_data_service.dart';

main() {
  group('METARS', () {
    test('1 Station and hoursBeforeNow=1', () async {
      var data = await downloadAsXml(
        WXTextDataType.metars,
        stations: ['KSFO'],
        options: WXOptions(hoursBeforeNow: 1),
      );
      var metarTags = data.findElements('METAR');
      expect(metarTags.length, 1);
    });

    test('1 Station and hoursBeforeNow=1', () async {
      var data = await downloadAsXml(
        WXTextDataType.metars,
        stations: ['KSFO'],
        options: WXOptions(hoursBeforeNow: 1),
      );
      var metarTags = data.findElements('METAR');
      expect(metarTags.length, 1);
    });

    test('1 Station and timeRange of 10 hours ago', () async {
      var end = DateTime.now();
      var start = end.subtract(Duration(hours: 10));
      var timeRange = TimeRange.fromDateTime(start, end);
      var data = await downloadAsXml(
        WXTextDataType.metars,
        stations: ['KSFO'],
        options: WXOptions(timeRange: timeRange),
      );
      var metarTags = data.findElements('METAR');
      expect(metarTags.length, 11);
    });
  });

  group('METARS - Errors', () {
    test('1 Station and w/out hoursBeforeNow', () async {
      try {
        var data = await downloadAsXml(
          WXTextDataType.metars,
          stations: ['KSFO'],
          options: WXOptions(),
        );
        fail("Expected Argument Error");
      } on ArgumentError catch (e) {
        expect(e.message, 'Query must be constrained by time');
      }
    });

    test('1 Station and timeRange out of range yields no results.', () async {
      var end = DateTime.now().subtract(Duration(hours: 24 * 30));
      print('end: ${end.toIso8601String()}');
      var start = end.subtract(Duration(hours: 24));
      print('start: ${start.toIso8601String()}');
      var timeRange = TimeRange.fromDateTime(start, end);
      var data = await downloadAsXml(
        WXTextDataType.metars,
        stations: ['KSFO'],
        options: WXOptions(timeRange: timeRange),
      );
      var metarTags = data.findElements('METAR');
      expect(metarTags.length, 0);
    });
  });
}
