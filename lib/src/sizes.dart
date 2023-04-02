abstract class Sizes {
  static int getNumericFrameSize(int frameSize) {
    const headerSize = 10;
    const encodingSize = 1;

    return headerSize + encodingSize + frameSize;
  }

  static int getStringFrameSize(int frameSize) {
    const headerSize = 10;
    const encodingSize = 1;
    const bomSize = 2;
    final frameUtf16Size = frameSize * 2;

    return headerSize + encodingSize + bomSize + frameUtf16Size;
  }

  static int getLyricsFrameSize(int descriptionSize, int lyricsSize) {
    const headerSize = 10;
    const encodingSize = 1;
    const languageSize = 3;
    const bomSize = 2;
    final descriptionUtf16Size = descriptionSize * 2;
    const separatorSize = 2;
    final lyricsUtf16Size = lyricsSize * 2;

    return headerSize +
        encodingSize +
        languageSize +
        bomSize +
        descriptionUtf16Size +
        separatorSize +
        bomSize +
        lyricsUtf16Size;
  }

  static int getPictureFrameSize(int pictureSize, int mimeTypeSize, int descriptionSize, bool useUnicodeEncoding) {
    const headerSize = 10;
    const encodingSize = 1;
    const separatorSize = 1;
    const pictureTypeSize = 1;
    const bomSize = 2;
    final encodedDescriptionSize =
        useUnicodeEncoding ? bomSize + (descriptionSize + separatorSize) * 2 : descriptionSize + separatorSize;

    return headerSize +
        encodingSize +
        mimeTypeSize +
        separatorSize +
        pictureTypeSize +
        encodedDescriptionSize +
        pictureSize;
  }

  static int getCommentFrameSize(int descriptionSize, int textSize) {
    const headerSize = 10;
    const encodingSize = 1;
    const languageSize = 3;
    const bomSize = 2;
    final descriptionUtf16Size = descriptionSize * 2;
    const separatorSize = 2;
    final textUtf16Size = textSize * 2;

    return headerSize +
        encodingSize +
        languageSize +
        bomSize +
        descriptionUtf16Size +
        separatorSize +
        bomSize +
        textUtf16Size;
  }

  static int getPrivateFrameSize(int idSize, int dataSize) {
    const headerSize = 10;
    const separatorSize = 1;

    return headerSize + idSize + separatorSize + dataSize;
  }

  static int getUserStringFrameSize(int descriptionSize, int valueSize) {
    const headerSize = 10;
    const encodingSize = 1;
    const bomSize = 2;
    final descriptionUtf16Size = descriptionSize * 2;
    const separatorSize = 2;
    final valueUtf16Size = valueSize * 2;

    return headerSize + encodingSize + bomSize + descriptionUtf16Size + separatorSize + bomSize + valueUtf16Size;
  }

  static int getUrlLinkFrameSize(int urlSize) {
    const headerSize = 10;

    return headerSize + urlSize;
  }
}
