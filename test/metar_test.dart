import 'package:test/test.dart';
import 'package:aviation_wx/src/metar.dart';

void main() {
  test('METAR Empty Constructor', () {
    var metar = METAR();
    expect(metar.skyConditions, isNotNull);
    expect(metar.skyConditions.isEmpty, isTrue);
  });
}
