import 'dart:io';
import 'package:aviation_wx/src/forecast.dart';
import 'package:aviation_wx/src/utils/wx_string.dart';
import 'package:xml/xml.dart';

import '../metar.dart';
import '../sky_condition.dart';
import '../cloud_cover.dart';
import '../taf.dart';

Future<XmlElement> loadXMLFile(String path) async {
  File f = File(path);
  String xmlString = await f.readAsString();
  return parse(xmlString).rootElement;
}

/// Returns a map of [METAR]s grouped by station and observation time.
/// The param [stations] is a list of station identifiers in ICAO format
/// and [hoursBefore] is the number of hours earlier to return previous
/// [METAR]s for each of the [stations].
Map<String, List<METAR>> convertXmlToMetars(XmlElement rootNote) {
  Map<String, List<METAR>> metars = {};
  rootNote.findElements('METAR').forEach((node) {
    var metar = parseMETAR(node);
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

/// Creates a new instance of [METAR] from an [XmlElement] that should
/// follow the [METAR Field Descriptions](https://aviationweather.gov/dataserver/fields?datatype=metar)
METAR parseMETAR(XmlElement node) {
  var metar = METAR();
  node.children.forEach((node) {
    if (node.nodeType == XmlNodeType.ELEMENT) {
      XmlElement e = node;
      if (e.name.local == 'raw_text') {
        metar.rawText = e.text;
      } else if (e.name.local == 'station_id') {
        metar.station = e.text;
      } else if (e.name.local == 'observation_time') {
        metar.observationTime = DateTime.tryParse(e.text);
      } else if (e.name.local == 'latitude') {
        metar.latitude = double.parse(e.text);
      } else if (e.name.local == 'longitude') {
        metar.longitude = double.parse(e.text);
      } else if (e.name.local == 'temp_c') {
        metar.temp = double.parse(e.text);
      } else if (e.name.local == 'dewpoint_c') {
        metar.dewPoint = double.parse(e.text);
      } else if (e.name.local == 'wind_dir_degrees') {
        metar.windDirection = int.parse(e.text);
      } else if (e.name.local == 'wind_speed_kt') {
        metar.windSpeed = int.parse(e.text);
      } else if (e.name.local == 'wind_gust_kt') {
        metar.windGust = int.parse(e.text);
      } else if (e.name.local == 'visibility_statute_mi') {
        metar.visibility = double.parse(e.text);
      } else if (e.name.local == 'altim_in_hg') {
        metar.altimeter = double.parse(e.text);
      } else if (e.name.local == 'sea_level_pressure_mb') {
        metar.seaLevelPressure = double.parse(e.text);
      } else if (e.name.local == 'sky_condition') {
        metar.skyConditions.add(SkyCondition(
          cover: CloudCover.tryParse(e.getAttribute('sky_cover')),
          base: int.tryParse(e.getAttribute('cloud_base_ft_agl') ?? 'None'),
        ));
      } else if (e.name.local == 'flight_category') {
        metar.flightCategory = e.text;
      } else if (e.name.local == 'snow_in') {
        metar.snowDepth = double.parse(e.text);
      } else if (e.name.local == 'vert_vis_ft') {
        metar.verticalVisibility = int.parse(e.text);
      } else if (e.name.local == 'elevation_m') {
        metar.elevation = double.parse(e.text);
      } else if (e.name.local == 'precip_in') {
        metar.precipitation = double.parse(e.text);
      } else if (e.name.local == 'wx_string') {
        metar.wxString = WXString(e.text);
      }
    }
  });
  return metar;
}

/// Returns a map of [TAF]s grouped by station and observation time.
/// The param [stations] is a list of station identifiers in ICAO format
/// and [hoursBefore] is the number of hours earlier to return previous
/// [TAF]s for each of the [stations].
Map<String, List<TAF>> convertXmlToTafs(XmlElement rootNote) {
  Map<String, List<TAF>> tafs = {};
  rootNote.findElements('TAF').forEach((node) {
    var taf = parseTAF(node);
    if (tafs[taf.station] == null) {
      tafs[taf.station] = List();
    }
    tafs[taf.station].add(taf);
  });
  tafs.keys.forEach((station) {
    tafs[station].sort(
        (objectA, objectB) => objectA.issueTime.compareTo(objectB.issueTime));
  });

  return tafs;
}

/// Creates a new instance of [TAF] from an [XmlElement] that should
/// follow the [TAF Field Descriptions](https://aviationweather.gov/dataserver/fields?datatype=taf)
TAF parseTAF(XmlElement node) {
  var taf = TAF();
  node.children.forEach((node) {
    if (node.nodeType == XmlNodeType.ELEMENT) {
      XmlElement e = node;
      if (e.name.local == 'raw_text') {
        taf.rawText = e.text;
      } else if (e.name.local == 'station_id') {
        taf.station = e.text;
      } else if (e.name.local == 'issue_time') {
        taf.issueTime = DateTime.tryParse(e.text);
      } else if (e.name.local == 'latitude') {
        taf.latitude = double.parse(e.text);
      } else if (e.name.local == 'longitude') {
        taf.longitude = double.parse(e.text);
      } else if (e.name.local == 'elevation_m') {
        taf.elevation = double.parse(e.text);
      } else if (e.name.local == 'forecast') {
        taf.forecasts.add(parseForecast(e));
      }
    }
  });
  return taf;
}

Forecast parseForecast(XmlElement node) {
  var forecast = Forecast();
  node.children.forEach((node) {
    if (node.nodeType == XmlNodeType.ELEMENT) {
      XmlElement e = node;
      if (e.name.local == 'fcst_time_from') {
        forecast.timeFrom = DateTime.tryParse(e.text);
      } else if (e.name.local == 'fcst_time_to') {
        forecast.timeTo = DateTime.tryParse(e.text);
      } else if (e.name.local == 'wind_dir_degrees') {
        forecast.windDirection = int.parse(e.text);
      } else if (e.name.local == 'wind_speed_kt') {
        forecast.windSpeed = int.parse(e.text);
      } else if (e.name.local == 'wind_gust_kt') {
        forecast.windGust = int.parse(e.text);
      } else if (e.name.local == 'visibility_statute_mi') {
        forecast.visibility = double.parse(e.text);
      } else if (e.name.local == 'wx_string') {
        forecast.wxString = WXString(e.text);
      } else if (e.name.local == 'sky_condition') {
        forecast.skyConditions.add(SkyCondition(
          cover: CloudCover.tryParse(e.getAttribute('sky_cover')),
          base: int.tryParse(e.getAttribute('cloud_base_ft_agl') ?? 'None'),
        ));
      }
    }
  });
  return forecast;
}
