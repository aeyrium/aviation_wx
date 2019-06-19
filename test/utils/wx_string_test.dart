import 'package:test/test.dart';
import 'package:aviation_wx/src/utils/wx_string.dart';

main() {
  group('WXString Tests', () {
    test('Parse "-RA"', () {
      var wxString = WXString('-RA');
      expect(wxString.toString(), 'Light Rain');
    });

    test('Parse "RA"', () {
      var wxString = WXString('RA');
      expect(wxString.toString(), 'Moderate Rain');
    });

    test('Parse "-SHRA"', () {
      var wxString = WXString('-SHRA');
      expect(wxString.toString(), 'Light Rain Shower(s)');
    });

    test('Parse "+FC"', () {
      var wxString = WXString('+FC');
      expect(wxString.toString(), 'Heavy Funnel Cloud Tornado Waterspout');
    });

    test('Parse "FZRA"', () {
      var wxString = WXString('FZRA');
      expect(wxString.toString(), 'Moderate Freezing Rain');
    });

    test('Parse "VCDRBR"', () {
      var wxString = WXString('VCDRBR');
      expect(wxString.toString(), 'In the Vicinity Low Drifting Mist');
    });
  });
}
