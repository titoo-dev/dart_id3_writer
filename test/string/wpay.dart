import 'dart:typed_data';

import 'package:dart_id3_writer/dart_id3_writer.dart';
import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('WPAY', () {
    test('WPAY', () {
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('WPAY', 'https://google.com');
      writter.addTag();
      final actual = writter.arrayBuffer;
      print('actual :: ${actual.sublist(0, 38)} length ${actual.length}');
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        28, // tag size without header
        ...Encoder.encodeWindows1252('WPAY'),
        0,
        0,
        0,
        18, // size without header
        0,
        0, // flags
        ...Encoder.encodeWindows1252('https://google.com'),
      ]);
      print('expected :: $expected length: ${expected.length}');
      expect(actual.sublist(0, expected.length), expected);
    });
  });
}
