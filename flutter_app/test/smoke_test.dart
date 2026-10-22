// Real, dependency-light smoke test for the content layer (no Hive/init needed).
import 'package:flutter_test/flutter_test.dart';
import 'package:mawaddah/main.dart' show LABELS;

void main() {
  test('LABELS locales share the same keys', () {
    final ar = LABELS['ar']!.keys.toSet();
    final en = LABELS['en']!.keys.toSet();
    expect(en.difference(ar), isEmpty,
        reason: 'en labels missing keys present in ar: ${en.difference(ar)}');
    expect(ar.difference(en), isEmpty,
        reason: 'ar labels missing keys present in en: ${ar.difference(en)}');
  });

  test('onboarding labels are non-empty', () {
    expect(LABELS['ar']!['appTitle'], isNotEmpty);
    expect(LABELS['en']!['start'], isNotEmpty);
  });
}
