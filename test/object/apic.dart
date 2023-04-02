import 'dart:typed_data';

import 'package:dart_id3_writer/dart_id3_writer.dart';
import 'package:dart_id3_writer/src/encoder.dart';
import 'package:test/test.dart';

import '../utils.dart';

const imageContent = [4, 8, 15, 16, 23, 42];

void main() {
  group('APIC', () {
    test('jpeg', () {
      const signature = [0xff, 0xd8, 0xff];
      final image = Uint8List.fromList([...signature, ...imageContent]);
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('APIC', {'type': 3, 'data': image, 'description': 'yo'});
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        35, // tag size without header
        ...Encoder.encodeWindows1252('APIC'),
        0,
        0,
        0,
        25, // size without header
        0,
        0, // flags
        0, // encoding
        ...Encoder.encodeWindows1252('image/jpeg'),
        0, // separator
        3, // pic type
        ...Encoder.encodeWindows1252('yo'),
        0, // separator
        ...signature,
        ...imageContent,
      ]);
      expect(actual, expected);
    });

    test('jpeg with useUnicodeEncoding', () {
      const signature = [0xff, 0xd8, 0xff];
      final image = Uint8List.fromList([...signature, ...imageContent]);
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('APIC', {'type': 3, 'data': image, 'description': 'yo', 'useUnicodeEncoding': true});
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        40, // tag size without header
        ...Encoder.encodeWindows1252('APIC'),
        0,
        0,
        0,
        30, // size without header
        0,
        0, // flags
        1, // encoding
        ...Encoder.encodeWindows1252('image/jpeg'),
        0, // separator
        3, // pic type
        0xff,
        0xfe, // BOM
        ...Encoder.encodeUtf16le('yo'),
        0,
        0, // separator
        ...signature,
        ...imageContent,
      ]);
      expect(actual, expected);
    });

    test('png', () {
      const signature = [0x89, 0x50, 0x4e, 0x47];
      final image = Uint8List.fromList([...signature, ...imageContent]);
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('APIC', {'type': 3, 'data': image, 'description': 'yo'});
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        35, // tag size without header
        ...Encoder.encodeWindows1252('APIC'),
        0,
        0,
        0,
        25, // size without header
        0,
        0, // flags
        0, // encoding
        ...Encoder.encodeWindows1252('image/png'),
        0, // separator
        3, // pic type
        ...Encoder.encodeWindows1252('yo'),
        0, // separator
        ...signature,
        ...imageContent,
      ]);
      expect(actual, expected);
    });

    test('gif', () {
      const signature = [0x47, 0x49, 0x46];
      final image = Uint8List.fromList([...signature, ...imageContent]);
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('APIC', {'type': 3, 'data': image, 'description': 'yo'});
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        34, // tag size without header
        ...Encoder.encodeWindows1252('APIC'),
        0,
        0,
        0,
        24, // size without header
        0,
        0, // flags
        0, // encoding
        ...Encoder.encodeWindows1252('image/gif'),
        0, // separator
        3, // pic type
        ...Encoder.encodeWindows1252('yo'),
        0, // separator
        ...signature,
        ...imageContent,
      ]);
      expect(actual, expected);
    });

    test('webp', () {
      const signature = [0, 0, 0, 0, 0, 0, 0, 0, 0x57, 0x45, 0x42, 0x50];
      final image = Uint8List.fromList([...signature, ...imageContent]);
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('APIC', {'type': 3, 'data': image, 'description': 'yo'});
      writter.addTag();
      final actual = writter.arrayBuffer;
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        44, // tag size without header
        ...Encoder.encodeWindows1252('APIC'),
        0,
        0,
        0,
        34, // size without header
        0,
        0, // flags
        0, // encoding
        ...Encoder.encodeWindows1252('image/webp'),
        0, // separator
        3, // pic type
        ...Encoder.encodeWindows1252('yo'),
        0, // separator
        ...signature,
        ...imageContent,
      ]);
      expect(actual, expected);
    });

    test('tiff', () {
      const signature = [0x49, 0x49, 0x2a, 0];
      final image = Uint8List.fromList([...signature, ...imageContent]);
      final writter = ID3Writter(arrayBuffer: Utils.getEmptyBuffer());
      writter.padding = 0;
      writter.setFrame('APIC', {'type': 3, 'data': image, 'description': 'yo'});
      writter.addTag();
      final actual = writter.arrayBuffer;
      print('actual: $actual length ${actual.length}');
      final expected = Uint8List.fromList([
        ...Utils.id3Header,
        0,
        0,
        0,
        36, // tag size without header
        ...Encoder.encodeWindows1252('APIC'),
        0,
        0,
        0,
        26, // size without header
        0,
        0, // flags
        0, // encoding
        ...Encoder.encodeWindows1252('image/tiff'),
        0, // separator
        3, // pic type
        ...Encoder.encodeWindows1252('yo'),
        0, // separator
        ...signature,
        ...imageContent,
      ]);

      print('expected: $expected length ${expected.length}');
      expect(actual, expected);
    });
  });
}
