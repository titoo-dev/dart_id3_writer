import 'dart:typed_data';

import 'package:dart_id3_writer/dart_id3_writer.dart';
import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('TIT2', () {
    test('TIT2', () {
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('TIT2', 'Forge');
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        23, // tag size without header
        ...Encoder.encodeWindows1252('TIT2'),
        0,
        0,
        0,
        13, // frame size without header
        0,
        0, // flags
        1, // encoding
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('Forge'),
      ]);
      expect(actual, expected);
    });
  });
}
