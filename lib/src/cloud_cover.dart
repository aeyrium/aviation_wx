/// Used in the description of [SkyCondition] to provide
/// a way to express the type of clouds in the area.
/// [CloudCover] is typically expressed in a [METAR] or
/// [TAF] as a [code] in the [rawText].
///
/// The types of [CloudCover] are:
/// * [BKN] - Broken cloud layer 5/8ths to 7/8ths
/// * [CB] - Cumulonimbus
/// * [CLR] - Sky Clear at or below 12,000AGL
/// * [FEW] - Few cloud layer 0/8ths to 2/8ths
/// * [OVC] - Overcast cloud layer 8/8ths coverage
/// * [SCT] - Scattered cloud layer 3/8ths to 4/8ths
/// * [SKC] - Sky Clear
/// * [TCU] - Towering Cumulus
/// * [CAVOK] - Ceiling and visibility OK
/// * [OVX] - Present when [METAR.verticalVisibility] is reported
class CloudCover {
  /// A code that is found in the [rawText] of a [METAR]
  /// or [TAF] [SkyCondition].
  final String code;

  /// A user friendly short description of the [code]
  final String description;

  const CloudCover._(this.code, this.description);

  @override
  String toString() {
    return code;
  }

  /// Tries to parse code into a known [CloudCover] type
  /// and if no match is found will create a new CloudCover
  /// using the [code] as both code and [description]
  static CloudCover tryParse(String code) {
    switch (code.toUpperCase()) {
      case 'BKN':
        return BKN;
      case 'CB':
        return CB;
      case 'CLR':
        return CLR;
      case 'FEW':
        return FEW;
      case 'OVC':
        return OVC;
      case 'SCT':
        return SCT;
      case 'SKC':
        return SKC;
      case 'TCU':
        return TCU;
      case 'CAVOK':
        return CAVOK;
      default:
        return CloudCover._(code, code);
    }
  }

  /// Broken cloud layer 5/8ths to 7/8ths
  static const CloudCover BKN = CloudCover._('BKN', 'Broken');

  /// Cumulonimbus
  static const CloudCover CB = CloudCover._('CB', 'Cumulonimbus');

  /// Sky clear at or below 12,000AGL
  static const CloudCover CLR = CloudCover._('CLR', 'Sky Clear');

  /// Few cloud layer 0/8ths to 2/8ths
  static const CloudCover FEW = CloudCover._('FEW', 'Few Clouds');

  /// Overcast cloud layer 8/8ths coverage
  static const CloudCover OVC = CloudCover._('OVC', 'Overcast');

  /// Scattered cloud layer 3/8ths to 4/8ths
  static const CloudCover SCT = CloudCover._('SCT', 'Scattered');

  /// Sky Clear
  static const CloudCover SKC = CloudCover._('SKC', 'Sky Clear');

  /// Towering Cumulus
  static const CloudCover TCU = CloudCover._('TCU', 'Towering Cumulus');

  /// CAVOK - Ceiling and visibility OK
  static const CloudCover CAVOK =
      CloudCover._('CAVOK', 'Ceiling & Visibility OK');

  /// OVX present when vert_vis_ft is reported
  static const CloudCover OVX =
      CloudCover._('OVX', 'Vertical Visibility Reported');
}
