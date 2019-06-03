import 'package:test/test.dart';
import 'package:aviation_wx/src/utils/noaa_text_data.dart';

main() {
  group('NOAA Text Data', () {
    test('Get METARs', () async {
      var xmlMetars = await NOAATextData.downloadAsXml(
        'metars',
        1,
        ['KSFO', 'KOAK'],
      );
      expect(xmlMetars.length, 2);
      xmlMetars.forEach((e) {
        expect(e.name.local, 'METAR');
      });
    });

    test('Get TAFs', () async {
      var xmlMetars = await NOAATextData.downloadAsXml(
        'tafs',
        1,
        ['KSFO', 'KOAK'],
      );
      expect(xmlMetars.length, greaterThan(0));
      xmlMetars.forEach((e) {
        expect(e.name.local, 'TAF');
      });
    });

    test('Get Sations', () async {
      var xmlMetars = await NOAATextData.downloadAsXml(
        'stations',
        1,
        ['KSFO', 'KOAK'],
      );
      expect(xmlMetars.length, 2);
      xmlMetars.forEach((e) {
        expect(e.name.local, 'Station');
      });
    });

    test('Response 200 with errors', () async {
      expect(
          () async =>
              await NOAATextData.downloadAsXml('badvalue', 1, ['KSFO', 'KOAK']),
          throwsArgumentError);
    });
  });
}
