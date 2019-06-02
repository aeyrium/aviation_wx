import 'package:test/test.dart';
import 'package:aviation_wx/aviation_wx.dart';

void main() {
  test('Download KRNO and KSFO METARs', () async {
    List<String> stations = ['KRNO', 'KSFO'];
    List<METAR> metars = await WeatherService.downloadMETARs(stations, 1);
    metars.forEach((metar) {
      print('Here is: ${metar.station} ${metar.observationTime}');
    });
    expect(metars.length, greaterThan(1));
    expect(metars[0].station, isIn(stations));
    expect(metars[1].station, isIn(stations));
  });

  test('Download METARs with not results', () async {
    List<String> stations = ['Kxxx', 'KS55'];
    List<METAR> metars = await WeatherService.downloadMETARs(stations, 1);
    expect(metars.length, 0);
  });

  test('Download METARs with bad data', () async {
    List<String> stations = ['Kxxx', 'KS55'];
    expect(
      () => WeatherService.downloadMETARs(stations, -1),
      throwsArgumentError,
    );
  });
}
