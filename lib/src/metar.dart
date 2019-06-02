import 'package:xml/xml.dart';

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
  double snowDepth = 0;

  /// Vertical visibility (in feet)
  int verticalVisibility;

  /// The elevation of the station that reported this METAR (in meters)
  double elevation;

  /// Creates a new instance of [METAR] from an [XmlElement] that should
  /// follow the [METAR Field Descriptions](https://aviationweather.gov/dataserver/fields?datatype=metar)
  METAR.fromXmlElement(XmlElement node) {
    node.children.forEach((node) {
      if (node.nodeType == XmlNodeType.ELEMENT) {
        XmlElement e = node;
        if (e.name.local == 'raw_text') {
          rawText = e.text;
        } else if (e.name.local == 'station_id') {
          station = e.text;
        } else if (e.name.local == 'observation_time') {
          observationTime = DateTime.tryParse(e.text);
        } else if (e.name.local == 'latitude') {
          latitude = double.parse(e.text);
        } else if (e.name.local == 'longitude') {
          longitude = double.parse(e.text);
        } else if (e.name.local == 'temp_c') {
          temp = double.parse(e.text);
        } else if (e.name.local == 'dewpoint_c') {
          dewPoint = double.parse(e.text);
        } else if (e.name.local == 'wind_dir_degrees') {
          windDirection = int.parse(e.text);
        } else if (e.name.local == 'wind_speed_kt') {
          windSpeed = int.parse(e.text);
        } else if (e.name.local == 'wind_gust_kt') {
          windGust = int.parse(e.text);
        } else if (e.name.local == 'visibility_statute_mi') {
          visibility = double.parse(e.text);
        } else if (e.name.local == 'altim_in_hg') {
          altimeter = double.parse(e.text);
        } else if (e.name.local == 'sea_level_pressure_mb') {
          seaLevelPressure = double.parse(e.text);
        } else if (e.name.local == 'sky_condition') {
          skyConditions.add(SkyCondition(
            cover: e.getAttribute('sky_cover'),
            base: int.parse(e.getAttribute('cloud_base_ft_agl')),
          ));
        } else if (e.name.local == 'flight_category') {
          flightCategory = e.text;
        } else if (e.name.local == 'snow_in') {
          snowDepth = double.parse(e.text);
        } else if (e.name.local == 'vert_vis_ft') {
          verticalVisibility = int.parse(e.text);
        } else if (e.name.local == 'elevation_m') {
          elevation = double.parse(e.text);
        } else if (e.name.local == 'precip_in') {
          precipitation = double.parse(e.text);
        }
      }
    });
  }
}

class SkyCondition {
  String cover;
  int base;

  SkyCondition({this.cover, this.base});
}
