import 'sky_condition.dart';
import 'utils/wx_string.dart';

class Forecast {
  /// Time( in ISO8601 date/time format) this Forecast is from.
  DateTime timeFrom;

  /// Time( in ISO8601 date/time format) this Forecast is to.
  DateTime timeTo;

  /// Direction from which the wind is blowing (in decimal degrees). 0 degrees=variable wind direction.
  int windDirection;

  /// Wind speed (in Knots); 0 degree [windDirection] and 0 [windSpeed] = calm winds
  int windSpeed;

  /// Wind gust (in Knots)
  int windGust = 0;

  /// Horizontal visibility (in statute miles)
  double visibility;

  /// See [wx string descriptions](https://aviationweather.gov/docs/metar/wxSymbols_anno2.pdf)
  WXString wxString;

  /// May contain up to four levels of sky cover and base can be reported under the sky_conditions field;
  /// OVX present when vert_vis_ft is reported.
  /// Allowed values: SKC|CLR|CAVOK|FEW|SCT|BKN|OVC|OVX
  List<SkyCondition> skyConditions = List();

  Forecast({
    this.windDirection,
    this.windSpeed = 0,
    this.windGust = 0,
    this.wxString,
    List<SkyCondition> skyConditions,
    this.visibility,
  }) {
    if (skyConditions != null) {
      this.skyConditions.addAll(skyConditions);
    }
  }

  bool get hasSkyClear =>
      skyConditions != null &&
      skyConditions.length == 1 &&
      skyConditions.first.cover?.code?.toUpperCase() == "CLR";
}
