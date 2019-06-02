import './nooa_text_data.dart';
import './metar.dart';

class WeatherService {
  static Future<Map<String, List<METAR>>> downloadMETARs(
    List<String> stations,
    int hoursBefore,
  ) async {
    var xmlnodes =
        await NOOATextData.downloadAsXml('metars', hoursBefore, stations);
    Map<String, List<METAR>> metars = {};

    xmlnodes.forEach((node) {
      var metar = METAR.fromXmlElement(node);
      if (metars[metar.station] == null) {
        metars[metar.station] = List();
      }
      metars[metar.station].add(metar);
    });

    metars.keys.forEach((station) {
      metars[station].sort((metarA, metarB) =>
          metarA.observationTime.compareTo(metarB.observationTime));
    });

    return metars;
  }
}
