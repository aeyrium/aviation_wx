class WXOptions {
  double hoursBeforeNow;

  /// A time range filter for [METAR] or [TAF] queries.
  /// **NOTE**: Only the last 3 days of data is available.
  TimeRange timeRange;

  /// If true will return only the most recent [METAR] or [TAF].
  /// **NOTE** If a [TimeRange] is also specified and this is set
  /// to **true**, then the most recent [METAR] or [TAF] will be
  /// returns for that time range.
  bool mostRecent;

  /// Only for [TAF] querries that use [TimeRange] or specify a
  /// [hoursBeforeNow] value, if **true** include only issue times
  /// (typeType=issue).
  bool issue;

  /// Limits the [METAR] or [TAF] to stations located within the
  /// specified radius.
  RadialDistance radius;

  /// obtain [METAR]s or [TAF]s collected within a rectangular
  /// area (bounding box) defined by the min and max lon and lat
  LonLatRect area;

  /// The degree distance is the distance (based on longitude and latitude)
  /// between stations. The larger the value of minDegreeDistance, the less
  /// dense the results.  Duplicate stations are filtered and the most recent
  /// of duplicate stations is reported.
  ///
  /// Allowed values are between 0 and 90
  int minDegreeDistance;

  WXOptions({
    this.hoursBeforeNow = 1,
    this.timeRange,
    this.mostRecent = true,
    this.radius,
    this.area,
    this.minDegreeDistance,
  });
}

/// A time range utility class
class TimeRange {
  /// start time (in seconds) since January 1, 1970
  int start;

  /// end time (in seconds) since January 1, 1970
  int end;

  TimeRange(this.start, this.end);

  TimeRange.fromDateTime(DateTime start, DateTime end) {
    this.start = start.millisecondsSinceEpoch ~/ 0.001;
    this.end = end.millisecondsSinceEpoch ~/ 0.001;
  }

  TimeRange.fromUTCString(String start, String end) {
    TimeRange.fromDateTime(DateTime.parse(start), DateTime.parse(end));
  }
}

/// A rectangular area defined by min and max lat/long positions.
class LonLatRect {
  double _minLatitude;
  double _minLongitude;
  double _maxLatitude;
  double _maxLongitude;

  LonLatRect(
    double minLatitude,
    double maxLatitude,
    double minLongitude,
    double maxLongitude,
  ) {
    this.minLatitude = minLatitude;
    this.maxLatitude = maxLatitude;
    this.minLongitude = minLongitude;
    this.maxLongitude = maxLongitude;
  }

  double get minLatitude {
    return _minLatitude;
  }

  set minLatitude(double latitude) {
    this._minLatitude = _checkLatitude(latitude);
  }

  double get maxLatitude {
    return _maxLatitude;
  }

  set maxLatitude(double latitude) {
    this._maxLatitude = _checkLatitude(latitude);
  }

  double get minLongitude {
    return _minLongitude;
  }

  set minLongitude(double longitude) {
    this._minLongitude = _checkLongitude(longitude);
  }

  double get maxLongitude {
    return _maxLongitude;
  }

  set maxLongitude(double longitude) {
    this._maxLongitude = _checkLongitude(longitude);
  }
}

/// A [radius] (statute miles) around a point ([longitude] and [latitude] in decimal degrees)
/// * -180<= longitude <=180
/// * -90<= latitude <=90
/// * 0< radius <=500
/// **IMPORTANT** Described area may not cross the international dateline or either pole
class RadialDistance {
  double _latitude;
  double _longitude;
  int _radius;

  RadialDistance(double latitude, double longitude, int radius) {
    this.latitude = latitude;
    this.longitude = longitude;
    this.radius = radius;
  }

  double get latitude {
    return _latitude;
  }

  /// Must be -90<= [latitude] <=90
  set latitude(double latitude) {
    this._latitude = _checkLatitude(latitude);
  }

  double get longitude {
    return _longitude;
  }

  /// Must be -180<= [longitude] <=180
  set longitude(double longitude) {
    this._longitude = _checkLongitude(longitude);
  }

  int get radius {
    return _radius;
  }

  /// Must be 0< [radius] <=500
  set radius(int radius) {
    assert(radius >= 0 && radius <= 500, 'Invalid radius value of $radius.');
    this._radius = radius;
  }

  @override
  String toString() {
    return '$_radius;$_longitude,$_latitude';
  }
}

double _checkLongitude(double longitude) {
  assert(longitude >= -180.0 && longitude <= 180.0,
      'Invalid longitude value of $longitude.');
  return longitude;
}

double _checkLatitude(double latitude) {
  assert(latitude >= -180.0 && latitude <= 180.0,
      'Invalid latitude value of $latitude.');
  return latitude;
}
