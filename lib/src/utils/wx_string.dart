class WXString {
  String rawString;
  String intensity;
  String descriptor;
  String precipitation;
  String obscuration;
  String other;

  WXString(this.rawString) {
    var group1 = r'\-|\+|VC';
    var group2 = descriptors.keys.join('|');
    var group3 = precipitations.keys.join('|');
    var group4 = obscurations.keys.join('|');
    var group5 = others.keys.join('|');
    var regexp = RegExp('($group1)?($group2)?($group3)?($group4)?($group5)?');
    var match = regexp.firstMatch(rawString);
    intensity = intensities[match.group(1)];
    descriptor = descriptors[match.group(2)];
    precipitation = precipitations[match.group(3)];
    obscuration = obscurations[match.group(4)];
    other = others[match.group(5)];
  }

  @override
  String toString() {
    var out = '';
    var prefix;
    var suffix;

    if (intensity == 'VC') {
      prefix = '';
      suffix = 'in the vicinity';
    } else {
      prefix = (intensity ?? 'Moderate');
      suffix = '';
    }

    if (descriptor != null && !['Shower(s)', 'Patches'].contains(descriptor)) {
      out += descriptor + ' ';
    }

    if (precipitation != null) {
      out += '$precipitation ';
    }
    if (obscuration != null) {
      out += '$obscuration ';
    }
    if (other != null) {
      out += '$other ';
    }
    if (descriptor != null && ['Shower(s)', 'Patches'].contains(descriptor)) {
      out += descriptor;
    }
    return '$prefix $out $suffix'?.trim();
  }
}

const intensities = {
  '-': 'Light',
  '+': 'Heavy',
  'VC': 'In the Vicinity',
};

const descriptors = {
  'MI': 'Shallow',
  'PR': 'Partial',
  'BC': 'Patches',
  'DR': 'Low Drifting',
  'BL': 'Blowing',
  'SH': 'Shower(s)',
  'TS': 'Thunderstorm',
  'FZ': 'Freezing',
};

const precipitations = {
  'DZ': 'Drizzle',
  'RA': 'Rain',
  'SN': 'Snow',
  'SG': 'Snow Grains',
  'IC': 'Ice Crystals',
  'PL': 'Ice Pellets',
  'GR': 'Hail',
  'GS': 'Small Hail and/or Snow Pellets',
  'UP': 'Unknown Precipitation',
};

const obscurations = {
  'BR': 'Mist',
  'FG': 'Fog',
  'FU': 'Smoke',
  'VA': 'Volcanic Ash',
  'DU': 'Widespread Dust',
  'SA': 'Sand',
  'HZ': 'Haze',
  'PY': 'Spray',
};

const others = {
  'PO': 'Well- Developed Dust/Sand Whirls',
  'SQ': 'Squalls',
  'FC': 'Funnel Cloud Tornado Waterspout',
  'SS': 'Sandstorm',
};
