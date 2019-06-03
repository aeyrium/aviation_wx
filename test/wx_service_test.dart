import 'package:aviation_wx/src/utils/wx_options.dart';
import 'package:test/test.dart';
import 'package:aviation_wx/src/utils/wx_utils.dart';

void main() {
  test('Download KRNO and KSFO METARs', () async {
    var stations = ['KRNO', 'KSFO'];
    var metars = await downloadMETARs(stations, WXOptions(hoursBeforeNow: 1));
    expect(metars.keys.length, 2);
    expect(metars['KRNO'], isNotNull);
    expect(metars['KRNO'].length, greaterThan(0));
    expect(metars['KSFO'], isNotNull);
    expect(metars['KSFO'].length, greaterThan(0));
  });

  test('Download METARs with not results', () async {
    var stations = ['Kxxx', 'KS55'];
    var metars = await downloadMETARs(stations, WXOptions(hoursBeforeNow: 1));
    expect(metars.isEmpty, isTrue);
  });

  test('Download METARs with bad data', () async {
    var stations = ['Kxxx', 'KS55'];
    expect(
      () => downloadMETARs(stations, WXOptions(hoursBeforeNow: -1)),
      throwsArgumentError,
    );
  });

  test('Confirm results are sorted', () async {
    var stations = ['KMEV', 'KOAK', 'KRNO', 'KSFO'];
    var metars = await downloadMETARs(stations, WXOptions(hoursBeforeNow: 4));
    expect(metars.keys.length, 4);
    stations.forEach((station) {
      expect(metars[station], isNotNull);
      expect(metars[station].length, greaterThan(0));
      for (var ndx = 1; ndx < metars[station].length; ndx++) {
        expect(
            metars[station][ndx - 1]
                .observationTime
                .isBefore(metars[station][ndx].observationTime),
            isTrue);
      }
    });
  });
}
