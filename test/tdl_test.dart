import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/vision/tdl.dart';

void main() {
  group('TdlResult', () {
    test('kedua mata mencapai baris 3 = normal', () {
      const r = TdlResult(rightEyeLine: 3, leftEyeLine: 4);
      expect(r.rightStatus, TdlEyeStatus.normal);
      expect(r.leftStatus, TdlEyeStatus.normal);
      expect(r.hasImpairment, false);
      expect(r.affectedEyes, isEmpty);
    });

    test('mata hanya baris 2 = kemungkinan gangguan', () {
      const r = TdlResult(rightEyeLine: 2, leftEyeLine: 3);
      expect(r.rightStatus, TdlEyeStatus.suspectedImpairment);
      expect(r.leftStatus, TdlEyeStatus.normal);
      expect(r.hasImpairment, true);
      expect(r.affectedEyes, ['kanan']);
    });

    test('mata tidak terbaca (null) = kemungkinan gangguan', () {
      const r = TdlResult(rightEyeLine: null, leftEyeLine: 3);
      expect(r.rightStatus, TdlEyeStatus.suspectedImpairment);
      expect(r.hasImpairment, true);
      expect(r.affectedEyes, ['kanan']);
    });

    test('kedua mata bermasalah', () {
      const r = TdlResult(rightEyeLine: 1, leftEyeLine: null);
      expect(r.hasImpairment, true);
      expect(r.affectedEyes, ['kanan', 'kiri']);
    });

    test('ambang tepat di baris 3 dianggap normal', () {
      expect(TdlResult.eyeStatus(3), TdlEyeStatus.normal);
      expect(TdlResult.eyeStatus(2), TdlEyeStatus.suspectedImpairment);
    });

    test('interpretasi & rekomendasi sesuai status', () {
      const normal = TdlResult(rightEyeLine: 3, leftEyeLine: 3);
      expect(normal.interpretation, contains('normal'));
      expect(normal.recommendation, contains('6 bulan'));

      const impaired = TdlResult(rightEyeLine: 1, leftEyeLine: 4);
      expect(impaired.interpretation, contains('kanan'));
      expect(impaired.recommendation.toLowerCase(), contains('rujuk'));
    });
  });
}
