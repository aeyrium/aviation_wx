import 'package:test/test.dart';
import 'package:aviation_wx/src/cloud_cover.dart';
import 'package:aviation_wx/src/utils/wx_xml_mapper.dart';

void main() {
  test('METAR parseMETAR', () async {
    var xmlelement = await loadXMLFile('test/data/sample_metar_ksfo.xml');
    var metar = parseMETAR(xmlelement);

    expect(metar.rawText,
        'KSFO 220656Z 28016KT 8SM FEW017 SCT034 BKN060 12/09 A2987 RMK AO2 PK WND 28027/0643 RAB28E39 SLP115 P0000 T01170094');
    expect(metar.station, 'KSFO');
    expect(metar.observationTime.year, 2019); // '2019-05-22T06:56:00Z'
    expect(metar.observationTime.month, 5);
    expect(metar.observationTime.day, 22);
    expect(metar.observationTime.hour, 6);
    expect(metar.observationTime.minute, 56);
    expect(metar.observationTime.second, 0);
    expect(metar.observationTime.timeZoneName, 'UTC');
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

    expect(metar.skyConditions[0].cover, CloudCover.FEW);
    expect(metar.skyConditions[0].base, 1700);

    expect(metar.skyConditions[1].cover, CloudCover.SCT);
    expect(metar.skyConditions[1].base, 3400);

    expect(metar.skyConditions[2].cover, CloudCover.BKN);
    expect(metar.skyConditions[2].base, 6000);

    expect(metar.flightCategory, 'VFR');
    expect(metar.precipitation, 0.005);
    expect(metar.elevation, 3.0);

    expect(metar.wxString, null);
    expect(metar.snowDepth, 0);
    expect(metar.verticalVisibility, null);
  });
  test('Download KRNO and KSFO METARs', () async {
    var data = await loadXMLFile('test/data/sample_metars_data_2hrs.xml');
    var metars = convertXmlToMetars(data);
    expect(metars.keys.length, 2);
    expect(metars['KRNO'], isNotNull);
    expect(metars['KRNO'].length, greaterThan(0));
    expect(metars['KSFO'], isNotNull);
    expect(metars['KSFO'].length, greaterThan(0));
  });

  test('Download METARs with not results', () async {
    //var stations = ['Kxxx', 'KS55'];
    var data = await loadXMLFile('test/data/sample_empty_data.xml');
    var metars = convertXmlToMetars(data);
    expect(metars.isEmpty, isTrue);
  });

  test('Confirm results are sorted', () async {
    var stations = ['KMEV', 'KOAK', 'KRNO', 'KSFO'];
    var data = await loadXMLFile('test/data/sample_metars_data_4hrs.xml');
    var metars = convertXmlToMetars(data);
    expect(metars.keys.length, 4);
    stations.forEach((station) {
      expect(metars[station], isNotNull);
      expect(metars[station].length, greaterThan(0));
      for (var ndx = 1; ndx < metars[station].length; ndx++) {
        expect(
            metars[station][ndx - 1]
                .observationTime
                .isBefore(metars[station][ndx].observationTime),
            isTrue);
      }
    });
  });

  test('TAF parseTAF', () async {
    var data = await loadXMLFile('test/data/sample_taf_phto.xml');
    var taf = parseTAF(data);
    expect(taf.station, 'PHTO');
    expect(taf.issueTime.year, 2019);
    expect(taf.latitude, 19.72);
    expect(taf.longitude, -155.05);
    expect(taf.elevation, 12.0);
    expect(taf.forecasts.length, 3);
    expect(taf.forecasts[0].timeFrom.year, 2019);
    expect(taf.forecasts[0].timeTo.year, 2019);
    expect(taf.forecasts[0].windDirection, 230);
    expect(taf.forecasts[0].visibility, 6.21);
    expect(taf.forecasts[0].windSpeed, 5);
    expect(taf.forecasts[0].wxString.rawString, "VCSH");
    expect(taf.forecasts[0].skyConditions.length, 2);
    expect(taf.forecasts[0].skyConditions[0].base, 3000);
    expect(taf.forecasts[0].skyConditions[1].base, 4500);

    expect(taf.forecasts[1].timeFrom.year, 2019);
    expect(taf.forecasts[1].timeTo.year, 2019);
    expect(taf.forecasts[1].windDirection, 120);
    expect(taf.forecasts[1].visibility, 6.21);
    expect(taf.forecasts[1].windSpeed, 10);
    expect(taf.forecasts[1].wxString.rawString, "VCSH");
    expect(taf.forecasts[1].skyConditions.length, 2);
    expect(taf.forecasts[1].skyConditions[0].base, 2500);
    expect(taf.forecasts[1].skyConditions[1].base, 4500);
  });

  test('Download TAFs', () async {
    var data = await loadXMLFile('test/data/sample_tafs_data.xml');
    var tafs = convertXmlToTafs(data);
    expect(tafs[tafs.keys.first].length, 9);
  });
}
