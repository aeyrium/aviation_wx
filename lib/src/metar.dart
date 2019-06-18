import '../aviation_wx.dart';
import './sky_condition.dart';
import 'utils/wx_text_data_service.dart';
import 'utils/wx_xml_mapper.dart';

/// METAR is a format for reporting weather information. A METAR weather report is
/// predominantly used by pilots in fulfillment of a part of a pre-flight weather
/// briefing, and by meteorologists, who use aggregated METAR information to assist
/// in weather forecasting.
class METAR {
  /// The raw METAR
  String rawText;

  /// Station identifier; Always a four character alphanumeric( A-Z, 0-9)
  String station;

  /// Time( in ISO8601 date/time format) this METAR was observed.
  DateTime observationTime;

  /// The latitude (in decimal degrees )of the station that reported this METAR
  double latitude;

  /// The longitude (in decimal degrees) of the station that reported this METAR
  double longitude;

  /// Air temperature expressed (in celcius)
  double temp;

  /// Dewpoint temperature (in celcius)
  double dewPoint;

  /// Direction from which the wind is blowing (in decimal degrees). 0 degrees=variable wind direction.
  int windDirection;

  /// Wind speed (in Knots); 0 degree [windDirection] and 0 [windSpeed] = calm winds
  int windSpeed;

  /// Wind gust (in Knots)
  int windGust = 0;

  /// Horizontal visibility (in statute miles)
  double visibility;

  /// Altimeter (in hg)
  double altimeter;

  /// Sea-level pressure (in mb)
  double seaLevelPressure;

  /// Precipitation (in inches)
  double precipitation;

  /// See [wx string descriptions](https://aviationweather.gov/docs/metar/wxSymbols_anno2.pdf)
  String wxString;

  /// May contian up to four levels of sky cover and base can be reported under the sky_conditions field;
  /// OVX present when vert_vis_ft is reported.
  /// Allowed values: SKC|CLR|CAVOK|FEW|SCT|BKN|OVC|OVX
  List<SkyCondition> skyConditions = List();

  /// Flight category of this METAR.
  /// Values: VFR|MVFR|IFR|LIFR
  /// See [Aviation Weather - METAR](http://www.aviationweather.gov/metar/help?page=plot#fltcat)
  String flightCategory;

  /// Snow depth on the ground (in inches)
  double snowDepth;

  /// Vertical visibility (in feet)
  int verticalVisibility;

  /// The elevation of the station that reported this METAR (in meters)
  double elevation;

  METAR({
    this.rawText,
    this.station,
    this.observationTime,
    this.latitude,
    this.longitude,
    this.temp,
    this.dewPoint,
    this.windDirection,
    this.windSpeed = 0,
    this.windGust = 0,
    this.visibility,
    this.altimeter,
    this.seaLevelPressure,
    this.precipitation,
    this.wxString,
    //this.skyConditions,
    List<SkyCondition> skyConditions,
    this.flightCategory,
    this.snowDepth = 0,
    this.verticalVisibility,
    this.elevation,
  }) {
    if (skyConditions != null) {
      this.skyConditions.addAll(skyConditions);
    }
  }

  /// Retrieve a Map <station, [METAR]s> from station/stations and [WXOptions] option filters.
  static Future<Map<String, List<METAR>>> download({
    List<String> stations,
    WXOptions options,
  }) async {
    assert(stations != null);
    final metarXML = await downloadAsXml(
      WXTextDataType.metars,
      stations: stations,
      options: options ?? WXOptions(hoursBeforeNow: 3),
    );
    return convertXmlToMetars(metarXML);
  }
}
