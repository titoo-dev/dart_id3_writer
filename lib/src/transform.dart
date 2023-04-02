abstract class Transform {
  static List<int> uint32ToUint8Array(int uint32) {
    final eightBitMask = 0xff;

    return [
      (uint32 >> 24) & eightBitMask,
      (uint32 >> 16) & eightBitMask,
      (uint32 >> 8) & eightBitMask,
      uint32 & eightBitMask,
    ];
  }

  static List<int> uint28ToUint7Array(int uint28) {
    final sevenBitMask = 0x7f;

    return [
      (uint28 >> 21) & sevenBitMask,
      (uint28 >> 14) & sevenBitMask,
      (uint28 >> 7) & sevenBitMask,
      uint28 & sevenBitMask,
    ];
  }

  static int uint7ArrayToUint28(List<int> uint7Array) {
    return (uint7Array[0] << 21) + (uint7Array[1] << 14) + (uint7Array[2] << 7) + uint7Array[3];
  }
}
