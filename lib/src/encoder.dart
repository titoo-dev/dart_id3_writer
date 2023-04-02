import 'dart:typed_data';

abstract class Encoder {
  static List<int> strToCodePoints(String str) {
    return str.codeUnits;
  }

  static Uint8List encodeWindows1252(String value) {
    return Uint8List.fromList(strToCodePoints(value));
  }

  static Uint8List encodeUtf16le(String str) {
    final buffer = ByteData(str.length * 2);
    final u8 = Uint8List.view(buffer.buffer);
    final u16 = Uint16List.view(buffer.buffer);

    u16.setAll(0, strToCodePoints(str));
    return u8;
  }
}
