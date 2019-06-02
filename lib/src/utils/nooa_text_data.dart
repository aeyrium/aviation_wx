import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

/// Low-level wrapper around the NOOA Text Data Server
/// HTTP network requests protocols.
class NOOATextData {
  static Future<List<xml.XmlElement>> downloadAsXml(
    String type,
    int hoursBefore,
    List<String> stations,
  ) async {
    String stationString = stations.join(',');
    Map<String, dynamic> queryParams = {
      'dataSource': type,
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

    print('Calling ${uri.toString()}');

    http.Response response;
    try {
      response = await http.get(uri);
    } on Exception catch (e) {
      print('Network Error: $e');
      throw e;
    }
    var meta = NOOAResponseMeta();
    List<xml.XmlElement> data = List();
    if (response.statusCode == 200) {
      var document = xml.parse(response.body);
      document.rootElement.children.forEach((node) {
        if (node.nodeType == xml.XmlNodeType.ELEMENT) {
          xml.XmlElement e = node;
          switch (e.name.local) {
            case 'request_index':
              meta.requestIndex = e.text;
              break;
            case 'data_source':
              meta.dataSource = e.getAttribute('name');
              break;
            case 'errors':
              e.findElements('error').forEach((error) {
                meta.errors.add(error.text);
              });
              break;
            case 'warnings':
              e.findElements('warning').forEach((warning) {
                meta.warnings.add(warning.text);
              });
              break;
            case 'time_taken_ms':
              meta.timeTakenMillis = int.tryParse(e.text);
              break;
            case 'data':
              node.children.forEach((child) {
                if (child is xml.XmlElement) {
                  data.add(child);
                }
              });
          }
        }
      });
    }
    if (meta.hasErrors) {
      throw ArgumentError(meta.errors.first);
    }

    return data;
  }
}

class NOOAResponseMeta {
  String requestIndex;
  String dataSource;
  List<String> errors = [];
  List<String> warnings = [];
  int timeTakenMillis;

  bool get hasErrors {
    return errors.length > 0;
  }
}
