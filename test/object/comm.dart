import 'dart:typed_data';

import 'package:dart_id3_writer/dart_id3_writer.dart';
import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('COMM', () {
    test('COMM', () {
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('COMM', {
        'description': 'advert',
        'text': 'free hugs',
      });
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        50, // tag size without header
        ...Encoder.encodeWindows1252('COMM'),
        0,
        0,
        0,
        40, // size without header
        0,
        0, // flags
        1, // encoding
        ...Encoder.encodeWindows1252('eng'),
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('advert'),
        0,
        0,
        0xff,
        0xfe, // separator, BOM
        ...Encoder.encodeUtf16le('free hugs'),
      ]);
      expect(actual, expected);
    });

    test('Change language', () {
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('COMM', {
        'language': 'jpn',
        'description': 'この世界',
        'text': '俺の名前',
      });
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        36, // tag size without header
        ...Encoder.encodeWindows1252('COMM'),
        0,
        0,
        0,
        26, // size without header
        0,
        0, // flags
        1, // encoding
        ...Encoder.encodeWindows1252('jpn'),
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('この世界'),
        0,
        0, // separator
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('俺の名前'),
      ]);
      expect(actual, expected);
    });
  });
}
