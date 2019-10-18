import 'package:aviation_wx/src/forecast.dart';

import '../aviation_wx.dart';
import 'utils/wx_text_data_service.dart';
import 'utils/wx_xml_mapper.dart';

/// TAF is a format  a format for reporting weather forecast information, particularly as it relates to aviation.
/// TAFs are issued at least four times a day, every six hours, for major civil airfields: 0000, 0600, 1200 and 1800 UTC,
/// and generally apply to a 24- or 30-hour period, and an area within approximately five statute miles (8.0 km)
/// (or 5 nautical miles (9.3 km) in Canada) from the center of an airport runway complex.
/// TAFs are issued every three hours for military airfields and some civil airfields and cover a period ranging from 3 hours to 30 hours.
class TAF {
  /// The raw METAR
  String rawText;

  /// Time( in ISO8601 date/time format) when the forecast was prepared.
  DateTime issueTime;

  /// Station identifier; Always a four character alphanumeric( A-Z, 0-9)
  String station;

  /// The latitude (in decimal degrees )of the station that reported this METAR
  double latitude;

  /// The longitude (in decimal degrees) of the station that reported this METAR
  double longitude;

  /// The elevation of the station that reported this METAR (in meters)
  double elevation;

  ///The Forecast for each TAF
  List<Forecast> forecasts = List();

  TAF({
    this.rawText,
    this.station,
    this.latitude,
    this.longitude,
    this.issueTime,
    List<Forecast> forecasts,
    this.elevation,
  }) {
    if (forecasts != null) {
      this.forecasts.addAll(forecasts);
    }
  }

  /// Retrieve a Map <station, [METAR]s> from station/stations and [WXOptions] option filters.
  static Future<Map<String, List<TAF>>> download({
    List<String> stations,
    WXOptions options,
  }) async {
    final tafXML = await downloadAsXml(WXTextDataType.tafs,
        stations: stations,
        options: options ?? WXOptions(hoursBeforeNow: 3, mostRecent: true));
    return convertXmlToTafs(tafXML);
  }
}
