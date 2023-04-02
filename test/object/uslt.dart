import 'dart:typed_data';

import 'package:dart_id3_writer/dart_id3_writer.dart';
import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('USLT', () {
    test('USLT', () {
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('USLT', {
        'description': 'Ярл',
        'lyrics': 'Лирика',
      });
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        38, // tag size without header
        ...Encoder.encodeWindows1252('USLT'),
        0,
        0,
        0,
        28, // size without header
        0,
        0, // flags
        1, // encoding
        ...Encoder.encodeWindows1252('eng'),
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('Ярл'),
        0,
        0, // separator
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('Лирика'),
      ]);
      expect(actual, expected);
    });

    test('Change language', () {
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('USLT', {
        'language': 'rus',
        'description': 'Ярл',
        'lyrics': 'Лирика',
      });
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        38, // tag size without header
        ...Encoder.encodeWindows1252('USLT'),
        0,
        0,
        0,
        28, // size without header
        0,
        0, // flags
        1, // encoding
        ...Encoder.encodeWindows1252('rus'),
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('Ярл'),
        0,
        0, // separator
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('Лирика'),
      ]);
      expect(actual, expected);
    });
  });
}
