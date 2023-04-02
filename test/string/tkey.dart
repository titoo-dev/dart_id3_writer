import 'dart:typed_data';

import 'package:dart_id3_writer/dart_id3_writer.dart';
import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('TKEY', () {
    test('TKEY', () {
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('TKEY', 'C#');
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        17, // tag size without header
        ...Encoder.encodeWindows1252('TKEY'),
        0,
        0,
        0,
        7, // size without header
        0,
        0, // flags
        1, // encoding
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('C#'),
      ]);
      expect(actual, expected);
    });
  });
}
