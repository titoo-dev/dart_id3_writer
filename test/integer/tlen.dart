import 'dart:typed_data';

import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';
import 'package:dart_id3_writer/dart_id3_writer.dart';

import '../utils.dart';

void main() {
  group('TLEN', () {
    test('TLEN', () {
      final writer = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writer.padding = 0;
      writer.setFrame('TLEN', 7200000);
      writer.addTag();
      final actual = writer.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        18, // tag size without header
        ...Encoder.encodeWindows1252('TLEN'),
        0,
        0,
        0,
        8, // frame size without header
        0,
        0, // flags
        0, // encoding
        ...Encoder.encodeWindows1252('7200000'),
      ]);
      expect(actual, expected);
    });
  });
}
