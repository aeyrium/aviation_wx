class WXString {
  String rawString;
  WXIntensity intensity;
  WXDescriptor descriptor;
  WXType wxType;

  String get icon {
    return wxType?.icon;
  }

  WXString(this.rawString) {
    var group1 = r'\-|\+|VC';
    var group2 = 'MI|PR|BC|DR|BL|SH|TS|FZ';
    var group3 = r'\w{2}';
    var regexp = RegExp('($group1)?($group2)?($group3)?');
    var match = regexp.firstMatch(rawString);
    intensity = _parseWXLevel(match.group(1));
    descriptor = WXDescriptor.tryParse(match.group(2));
    wxType = WXType.tryParse(match.group(3));
  }

  WXIntensity _parseWXLevel(String str) {
    switch (str) {
      case '-':
        return WXIntensity.Light;
      case '+':
        return WXIntensity.Heavy;
      case 'VC':
        return WXIntensity.Nearby;
      default:
        return WXIntensity.Moderate;
    }
  }

  @override
  String toString() {
    var out = '';
    var prefix = '';
    var suffix = '';

    switch (intensity) {
      case WXIntensity.Light:
        prefix = 'Light';
        break;
      case WXIntensity.Heavy:
        prefix = 'Heavy';
        break;
      case WXIntensity.Nearby:
        suffix = 'Nearby';
        break;
      default:
        prefix = 'Moderate';
    }

    if (descriptor != null &&
        descriptor != WXDescriptor.SH &&
        descriptor != WXDescriptor.BC) {
      out += descriptor.label + ' ';
    }

    if (wxType != null) {
      out += wxType.label;
    }

    if (descriptor != null &&
        (descriptor == WXDescriptor.SH || descriptor == WXDescriptor.BC)) {
      out += ' ${descriptor.label}';
    }
    return '$prefix $out $suffix'?.trim();
  }
}

enum WXIntensity { Light, Moderate, Heavy, Nearby }

class WXDescriptor {
  final String code;
  final String label;
  const WXDescriptor._(this.code, this.label);
  static const MI = WXDescriptor._('MI', 'Shallow');
  static const PR = WXDescriptor._('PR', 'Partial');
  static const BC = WXDescriptor._('BC', 'Patches');
  static const DR = WXDescriptor._('DR', 'Low Drifting');
  static const BL = WXDescriptor._('BL', 'Blowing');
  static const SH = WXDescriptor._('SH', 'Shower(s)');
  static const TS = WXDescriptor._('TS', 'Thunderstorm');
  static const FZ = WXDescriptor._('FZ', 'Freezing');

  static WXDescriptor tryParse(String str) {
    switch (str) {
      case 'MI':
        return MI;
      case 'PR':
        return PR;
      case 'BC':
        return BC;
      case 'DR':
        return DR;
      case 'BL':
        return BL;
      case 'SH':
        return SH;
      case 'TS':
        return TS;
      case 'FZ':
        return FZ;
    }
    return null;
  }
}

class WXType extends WXDescriptor {
  final String icon;
  const WXType._(String code, String label, this.icon) : super._(code, label);
  static const DZ = WXType._('DZ', 'Drizzle', 'Clound-Drizzle-Alt');
  static const RA = WXType._('RA', 'Rain', 'Cloud-Rain');
  static const SN = WXType._('SN', 'Snow', 'Cloud-Snow-Alt');
  static const SG = WXType._('SG', 'Snow Grains', 'Cloud-Snow-Alt');
  static const IC = WXType._('IC', 'Ice Crystals', 'Cloud-Snow');
  static const PL = WXType._('PL', 'Ice Pellets', 'Cloud-Hail-Alt');
  static const GR = WXType._('GR', 'Hail', 'Cloud-Hail');
  static const GS = WXType._('GS', 'Small Hail', 'Cloud-Hail-Alt');
  static const UP = WXType._('UP', 'Unknown', 'Cloud-Rain');
  static const BR = WXType._('BR', 'Mist', 'Cloud-Fog-Alt');
  static const FG = WXType._('FG', 'Fog', 'Cloud-Fog');
  static const FU = WXType._('FU', 'Smoke', 'Cloud-Fog-Alt');
  static const VA = WXType._('VA', 'Volcanic Ash', 'Cloud-Fog-Alt');
  static const DU = WXType._('DU', 'Widespread Dust', 'Cloud-Fog-Alt');
  static const SA = WXType._('SA', 'Sand', 'Cloud-Fog-Alt');
  static const HZ = WXType._('HZ', 'Haze', 'Cloud-Fog-Alt');
  static const PY = WXType._('PY', 'Spray', 'Clound-Drizzle');
  static const PO = WXType._('PO', 'Dust Whirls', 'Cloud-Fog-Alt');
  static const SQ = WXType._('SQ', 'Squalls', 'Cloud-Wind');
  static const FC = WXType._('FC', 'Tornado', 'Tornado');
  static const SS = WXType._('SS', 'Sandstorm', 'Cloud-Fog-Alt');

  static WXType tryParse(String str) {
    switch (str) {
      case 'DZ':
        return DZ;
      case 'RA':
        return RA;
      case 'SN':
        return SN;
      case 'SG':
        return SG;
      case 'IC':
        return IC;
      case 'PL':
        return PL;
      case 'GR':
        return GR;
      case 'GS':
        return GS;
      case 'UP':
        return UP;
      case 'BR':
        return BR;
      case 'FG':
        return FG;
      case 'FU':
        return FU;
      case 'VA':
        return VA;
      case 'DU':
        return DU;
      case 'SA':
        return SA;
      case 'HZ':
        return HZ;
      case 'PY':
        return PY;
      case 'PO':
        return PO;
      case 'SQ':
        return SQ;
      case 'FC':
        return FC;
      case 'SS':
        return SS;
    }
    return null;
  }
}
