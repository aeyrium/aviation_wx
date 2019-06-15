import './wx_options.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

/// Low-level wrapper around the NOAA Text Data Server
/// HTTP network requests protocols.
Future<xml.XmlElement> downloadAsXml(
  WXTextDataType type, {
  List<String> stations,
  WXOptions options,
}) async {
  String stationString = stations.join(',');
  Map<String, dynamic> queryParams = options?.toQueryParams() ?? {};
  queryParams['stationString'] = stationString;
  queryParams['dataSource'] = type.toString().split('.')[1];
  queryParams['requestType'] = 'retrieve';
  queryParams['format'] = 'xml';

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
  var meta = WXResponseMeta();
  xml.XmlElement data;
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
            data = node;
        }
      }
    });
  }
  if (meta.hasErrors) {
    throw ArgumentError(meta.errors.first);
  }

  if (meta.hasWarnings) {
    meta.warnings.forEach((warning) {
      print('WARNING: $warning');
    });
  }

  return data;
}

/// The supported download types for the Text Data Service
enum WXTextDataType { metars, tafs, stations }

/// The Meta info part of a Text Data Service repsonse
class WXResponseMeta {
  String requestIndex;
  String dataSource;
  List<String> errors = [];
  List<String> warnings = [];
  int timeTakenMillis;

  bool get hasErrors {
    return errors.length > 0;
  }

  bool get hasWarnings {
    return warnings.length > 0;
  }
}
