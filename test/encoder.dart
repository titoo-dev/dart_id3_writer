import 'dart:typed_data';

import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';

void main() {
  group('strToCodePoints', () {
    test('latin', () {
      expect(Encoder.strToCodePoints('Hello'), [72, 101, 108, 108, 111]);
    });
    test('cyrillic', () {
      expect(Encoder.strToCodePoints('Привет'), [1055, 1088, 1080, 1074, 1077, 1090]);
    });
  });

  group(
      'encodeWindows1252',
      () => {
            test('latin', () {
              expect(Encoder.encodeWindows1252('Hello'), Uint8List.fromList([72, 101, 108, 108, 111]));
            }),
            test('cyrillic', () {
              expect(Encoder.encodeWindows1252('Привет'), Uint8List.fromList([31, 64, 56, 50, 53, 66]));
            }),
          });

  group('encodeUtf16le', () {
    test('latin', () {
      expect(Encoder.encodeUtf16le('Hello'), Uint8List.fromList([72, 0, 101, 0, 108, 0, 108, 0, 111, 0]));
    });
    test('cyrillic', () {
      expect(Encoder.encodeUtf16le('Привет'), Uint8List.fromList([31, 4, 64, 4, 56, 4, 50, 4, 53, 4, 66, 4]));
    });
  });
}
