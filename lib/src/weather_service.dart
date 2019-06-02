import './nooa_text_data.dart';
import './metar.dart';

class WeatherService {
  static Future<List<METAR>> downloadMETARs(
    List<String> stations,
    int hoursBefore,
  ) async {
    var xmlnodes =
        await NOOATextData.downloadAsXml('metars', hoursBefore, stations);
    List<METAR> metars = List();

    xmlnodes.forEach((node) {
      metars.add(METAR.fromXmlElement(node));
    });

    return metars;
  }
}
