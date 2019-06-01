import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import './metar.dart';

class WeatherService {
  static Future<List<METAR>> downloadMETAR(
    List<String> stations,
    int hoursBefore,
  ) async {
    var response = await _downloadXml('metars', 1, stations);

    var metars = List<METAR>();
    if (response.statusCode == 200) {
      var document = xml.parse(response.body);

      var issues = _printErrorsAndWarnings(document);

      document.findAllElements('METAR').forEach((node) {
        metars.add(METAR.fromXmlElement(node));
      });
    }
    return metars;
  }
}

Future<http.Response> _downloadXml(
  String type,
  int hoursBefore,
  List<String> stations,
) {
  String stationString = stations.join(',');
  Map<String, dynamic> queryParams = {
    'dataSource': 'metars',
    'requestType': 'retrieve',
    'format': 'xml',
    'hoursBeforeNow': hoursBefore.toString(),
    'stationString': stationString,
  };
  Uri uri = Uri(
    scheme: 'https',
    host: 'aviationweather.gov',
    path: '/adds/dataserver_current/httpparam',
    queryParameters: queryParams,
  );

  return http.get(uri);
}

List<String> _printErrorsAndWarnings(xml.XmlDocument document) {
  var issues = List<String>();
  document.findAllElements('error').forEach((node) {
    xml.XmlElement e = node;
    print('Error: ${e.text}');
    issues.add(e.text);
  });

  document.findAllElements('warning').forEach((node) {
    xml.XmlElement e = node;
    print('Error: ${e.text}');
    issues.add(e.text);
  });

  return issues;
}
