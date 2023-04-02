import 'dart:typed_data';

import 'package:dart_id3_writer/dart_id3_writer.dart';
import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('TXXX', () {
    test('TXXX', () {
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('TXXX', {
        'description': 'foo',
        'value': 'bar',
      });
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        29, // tag size without header
        ...Encoder.encodeWindows1252('TXXX'),
        0,
        0,
        0,
        19, // size without header
        0,
        0, // flags
        1, // encoding
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('foo'),
        0,
        0, // separator
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('bar'),
      ]);
      expect(actual, expected);
    });
  });
}
