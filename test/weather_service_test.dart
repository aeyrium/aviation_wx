import 'dart:io';
import 'package:test/test.dart';
import 'package:xml/xml.dart' as xml;
import 'package:aviation_wx/aviation_ws.dart';

void main() {
  test('Download KRNO and KSFO METARs', () async {
    List<String> stations = ['KRNO', 'KSFO'];
    List<METAR> metars = await WeatherService.downloadMETAR(stations, 1);
    metars.forEach((metar) {
      print('Here is: ${metar.station} ${metar.observationTime}');
    });
    expect(metars.length, 2);
    expect(metars[0].station, 'KRNO');
    expect(metars[1].station, 'KSFO');
  });

  test('Download METARs with Errors', () async {
    List<String> stations = ['Kxxx', 'KS55'];
    List<METAR> metars = await WeatherService.downloadMETAR(stations, 1);
    metars.forEach((metar) {
      print('Here is: ${metar.station} ${metar.observationTime}');
    });
    expect(metars.length, 0);
  });

  test('METAR fromXmlElement', () async {
    var document = await _loadXML('test/data/sample_metar_ksfo.xml');
    var metar = METAR.fromXmlElement(document.rootElement);

    expect(metar.rawText,
        'KSFO 220656Z 28016KT 8SM FEW017 SCT034 BKN060 12/09 A2987 RMK AO2 PK WND 28027/0643 RAB28E39 SLP115 P0000 T01170094');
    expect(metar.station, 'KSFO');
    expect(metar.observationTime, '2019-05-22T06:56:00Z');
    expect(metar.latitude, 37.62);
    expect(metar.longitude, -122.37);
    expect(metar.temp, 11.7);
    expect(metar.dewPoint, 9.4);
    expect(metar.windDirection, 280);
    expect(metar.windSpeed, 16);
    expect(metar.visibility, 8.0);
    expect(metar.altimeter, 29.870079);
    expect(metar.seaLevelPressure, 1011.5);
    expect(metar.skyConditions.length, 3);

    expect(metar.skyConditions[0].cover, 'FEW');
    expect(metar.skyConditions[0].base, 1700);

    expect(metar.skyConditions[1].cover, 'SCT');
    expect(metar.skyConditions[1].base, 3400);

    expect(metar.skyConditions[2].cover, 'BKN');
    expect(metar.skyConditions[2].base, 6000);

    expect(metar.flightCategory, 'VFR');
    expect(metar.precipitation, 0.005);
    expect(metar.elevation, 3.0);

    expect(metar.wxString, null);
    expect(metar.snowDepth, 0);
    expect(metar.verticalVisibility, null);
  });
}

_loadXML(String path) async {
  File f = File('test/data/sample_metar_ksfo.xml');
  String xmlString = await f.readAsString();
  return xml.parse(xmlString);
}
