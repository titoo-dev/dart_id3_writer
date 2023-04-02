abstract class Signatures {
  static bool isId3v2(List<int> buf) {
    return buf[0] == 0x49 && buf[1] == 0x44 && buf[2] == 0x33;
  }

  static String? getMimeType(List<int>? buf) {
    if (buf == null || buf.isEmpty) {
      return null;
    }
    if (buf[0] == 0xff && buf[1] == 0xd8 && buf[2] == 0xff) {
      return 'image/jpeg';
    }
    if (buf[0] == 0x89 && buf[1] == 0x50 && buf[2] == 0x4e && buf[3] == 0x47) {
      return 'image/png';
    }
    if (buf[0] == 0x47 && buf[1] == 0x49 && buf[2] == 0x46) {
      return 'image/gif';
    }
    if (buf[8] == 0x57 && buf[9] == 0x45 && buf[10] == 0x42 && buf[11] == 0x50) {
      return 'image/webp';
    }
    bool isLeTiff = buf[0] == 0x49 && buf[1] == 0x49 && buf[2] == 0x2a && buf[3] == 0;
    bool isBeTiff = buf[0] == 0x4d && buf[1] == 0x4d && buf[2] == 0 && buf[3] == 0x2a;
    if (isLeTiff || isBeTiff) {
      return 'image/tiff';
    }
    if (buf[0] == 0x42 && buf[1] == 0x4d) {
      return 'image/bmp';
    }
    if (buf[0] == 0 && buf[1] == 0 && buf[2] == 1 && buf[3] == 0) {
      return 'image/x-icon';
    }
    return null;
  }
}

// generate test for lib\src\signatures.dart
void main() {
  // test isId3v2
  print(Signatures.isId3v2([0x49, 0x44, 0x33, 0x00]));

  // test getMimeType
  print(Signatures.getMimeType([0xff, 0xd8, 0xff]));
}
