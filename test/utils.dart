import 'dart:typed_data';

abstract class Utils {
  static const id3Header = [
    73,
    68,
    51, // ID3 magic nubmer
    3,
    0, // version
    0, // flags
  ];

  static Uint8List getEmptyBuffer() {
    return Uint8List(0);
  }
}
