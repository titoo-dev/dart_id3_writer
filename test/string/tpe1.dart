import 'dart:typed_data';

import 'package:dart_id3_writer/dart_id3_writer.dart';
import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('TPE1', () {
    test('TPE1', () {
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('TPE1', ['Eminem', '50 Cent']);
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        41, // tag size without header
        ...Encoder.encodeWindows1252('TPE1'),
        0,
        0,
        0,
        31, // frame size without header
        0,
        0, // flags
        1, // encoding
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('Eminem/50 Cent'),
      ]);
      expect(actual, expected);
    });
  });
}
