import 'package:test/test.dart';
import 'package:aviation_wx/aviation_ws.dart';

void main() {
  test('Download KRNO and KSFO METARs', () async {
    List<String> stations = ['KRNO', 'KSFO'];
    List<METAR> metars = await WeatherService.downloadMETAR(stations, 1);
    metars.forEach((metar) {
      print('Here is: ${metar.station} ${metar.observationTime}');
    });
    expect(metars.length, 2);
    expect(metars[0].station, isIn(stations));
    expect(metars[1].station, isIn(stations));
  });

  test('Download METARs with Errors', () async {
    List<String> stations = ['Kxxx', 'KS55'];
    List<METAR> metars = await WeatherService.downloadMETAR(stations, 1);
    metars.forEach((metar) {
      print('Here is: ${metar.station} ${metar.observationTime}');
    });
    expect(metars.length, 0);
  });
}
