import './cloud_cover.dart';

/// [SkyCondition] describes cloud conditions and is found in [METAR]
/// as well as [TAF] data.
class SkyCondition {
  CloudCover cover;

  /// The base of the [cover] in feet Above Ground Level (AGL)
  int base;

  SkyCondition({this.cover, this.base});
}
