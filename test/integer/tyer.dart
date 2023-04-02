import 'dart:typed_data';

import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';
import 'package:dart_id3_writer/dart_id3_writer.dart';

import '../utils.dart';

void main() {
  group('TYER', () {
    test('TYER', () {
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('TYER', 2011);
      writter.addTag();
      final actual = writter.arrayBuffer;
      print('actual: $actual');
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        15, // tag size without header
        ...Encoder.encodeWindows1252('TYER'),
        0,
        0,
        0,
        5, // frame size without header
        0,
        0, // flags
        0, // encoding
        ...Encoder.encodeWindows1252('2011'),
      ]);
      print('expected: $expected');
      expect(actual, expected);
    });
  });
}
