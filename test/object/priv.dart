import 'dart:typed_data';

import 'package:dart_id3_writer/dart_id3_writer.dart';
import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('PRIV', () {
    test('PRIV', () {
      final data = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9]);
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('PRIV', {
        'id': 'site.com',
        'data': data,
      });
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        28, // tag size without header
        ...Encoder.encodeWindows1252('PRIV'),
        0,
        0,
        0,
        18, // size without header
        0,
        0, // flags
        ...Encoder.encodeWindows1252('site.com'),
        0, // separator
        ...data,
      ]);
      expect(actual, expected);
    });
  });
}
