import 'dart:typed_data';

import 'package:dart_id3_writer/src/encoder.dart';
import 'package:dart_id3_writer/src/signatures.dart';
import 'package:dart_id3_writer/src/sizes.dart';
import 'package:dart_id3_writer/src/transform.dart';

class ID3Writter {
  Uint8List arrayBuffer;
  late int padding;
  List<Map<String, dynamic>> frames = [];
  late String url = '';

  ID3Writter({required this.arrayBuffer});

  void setIntegerFrame(String name, int value) {
    final int integer = value;

    frames.add({
      'name': name,
      'value': integer,
      'size': Sizes.getNumericFrameSize(integer.toString().length),
    });
  }

  void setStringFrame(String name, dynamic value) {
    final stringValue = value.toString();

    frames.add({
      'name': name,
      'value': stringValue,
      'size': Sizes.getStringFrameSize(stringValue.length),
    });
  }

  void setPictureFrame(int pictureType, List<int> data, String description, bool useUnicodeEncoding) {
    final mimeType = Signatures.getMimeType(Uint8List.fromList(data));
    final descriptionString = description.toString();

    if (mimeType == null) {
      throw ArgumentError('Unknown picture MIME type');
    }
    if (!description.isNotEmpty) {
      useUnicodeEncoding = false;
    }

    frames.add({
      'name': 'APIC',
      'value': data,
      'pictureType': pictureType,
      'mimeType': mimeType,
      'useUnicodeEncoding': useUnicodeEncoding,
      'description': descriptionString,
      'size': Sizes.getPictureFrameSize(
        data.length,
        mimeType.length,
        descriptionString.length,
        useUnicodeEncoding,
      ),
    });
  }

  void setLyricsFrame(String language, String description, String lyrics) {
    final languageCode = language.codeUnits;
    final descriptionString = description;
    final lyricsString = lyrics;

    frames.add({
      'name': 'USLT',
      'value': lyricsString,
      'language': languageCode,
      'description': descriptionString,
      'size': Sizes.getLyricsFrameSize(descriptionString.length, lyricsString.length),
    });
  }

  void setCommentFrame(String language, String description, String text) {
    final languageCode = language.codeUnits;
    final descriptionString = description;
    final textString = text;

    frames.add({
      'name': 'COMM',
      'value': textString,
      'language': languageCode,
      'description': descriptionString,
      'size': Sizes.getCommentFrameSize(descriptionString.length, textString.length),
    });
  }

  void setPrivateFrame(String id, List<int> data) {
    final identifier = id;

    frames.add({
      'name': 'PRIV',
      'value': data,
      'id': identifier,
      'size': Sizes.getPrivateFrameSize(identifier.length, data.length),
    });
  }

  void setUserStringFrame(String description, String value) {
    final String descriptionString = description.toString();
    final String valueString = value.toString();

    frames.add({
      'name': 'TXXX',
      'description': descriptionString,
      'value': valueString,
      'size': Sizes.getUserStringFrameSize(
        descriptionString.length,
        valueString.length,
      ),
    });
  }

  void setUrlLinkFrame(String name, String url) {
    final String urlString = url.toString();

    frames.add({
      'name': name,
      'value': urlString,
      'size': Sizes.getUrlLinkFrameSize(urlString.length),
    });
  }

  ID3Writter setFrame(String frameName, dynamic frameValue) {
    switch (frameName) {
      case 'TPE1': // song artists
      case 'TCOM': // song composers
      case 'TCON':
        // song genres
        if (frameValue is! List) {
          throw ArgumentError('$frameName frame value should be an array of strings');
        }
        final delemiter = frameName == 'TCON' ? ';' : '/';
        final value = frameValue.join(delemiter);

        setStringFrame(frameName, value);
        break;
      case 'TLAN': // language
      case 'TIT1': // content group description
      case 'TIT2': // song title
      case 'TIT3': // song subtitle
      case 'TALB': // album title
      case 'TPE2': // album artist // spec doesn't say anything about separator, so it is a string, not array
      case 'TPE3': // conductor/performer refinement
      case 'TPE4': // interpreted, remixed, or otherwise modified by
      case 'TRCK': // song number in album: 5 or 5/10
      case 'TPOS': // album disc number: 1 or 1/3
      case 'TMED': // media type
      case 'TPUB': // label name
      case 'TCOP': // copyright
      case 'TKEY': // musical key in which the sound starts
      case 'WPAY': // Payment
      case 'TEXT': // lyricist / text writer
      case 'TSRC':
        // isrc
        setStringFrame(frameName, frameValue);
        break;
      case 'TBPM': // beats per minute
      case 'TLEN': // song duration
      case 'TDAT': // album release date expressed as DDMM
      case 'TYER':
        // album release year
        setIntegerFrame(frameName, frameValue);
        break;
      case 'USLT':
        // unsychronised lyrics
        frameValue['language'] = frameValue['language'] ?? 'eng';
        if (frameValue is! Map || !frameValue.containsKey('description') || !frameValue.containsKey('lyrics')) {
          throw Exception('USLT frame value should be an object with keys description and lyrics');
        }
        if (frameValue.containsKey('language') &&
            !RegExp('[a-z]{3}', caseSensitive: false).hasMatch(frameValue['language']!)) {
          throw Exception('Language must be coded following the ISO 639-2 standards');
        }
        setLyricsFrame(frameValue['language']!, frameValue['description']!, frameValue['lyrics']!);
        break;
      case 'APIC':
        // song cover
        if (frameValue is! Map ||
            !frameValue.containsKey('type') ||
            !frameValue.containsKey('data') ||
            !frameValue.containsKey('description')) {
          throw Exception('APIC frame value should be a Map with keys type, data and description');
        }
        if (frameValue['type'] < 0 || frameValue['type'] > 20) {
          throw Exception('Incorrect APIC frame picture type');
        }

        setPictureFrame(
          frameValue['type'],
          frameValue['data'],
          frameValue['description'],
          frameValue['useUnicodeEncoding'] ?? false,
        );
        break;
      case 'TXXX':
        // user defined text information
        if (frameValue is! Map || !frameValue.containsKey('description') || !frameValue.containsKey('value')) {
          throw Exception('TXXX frame value should be an object with keys description and value');
        }

        setUserStringFrame(frameValue['description'], frameValue['value']);
        break;
      case 'COMM':
        {
          // Comments
          frameValue['language'] = frameValue['language'] ?? 'eng';
          if (frameValue is! Map || !frameValue.containsKey('description') || !frameValue.containsKey('text')) {
            throw Exception('COMM frame value should be an object with keys description and text');
          }
          if (frameValue['language'] != null &&
              !RegExp(r'[a-z]{3}', caseSensitive: false).hasMatch(frameValue['language'])) {
            throw Exception('Language must be coded following the ISO 639-2 standards');
          }
          setCommentFrame(frameValue['language'], frameValue['description'], frameValue['text']);
          break;
        }
      case 'PRIV':
        // Private frame
        if (frameValue is! Map || !frameValue.containsKey('id') || !frameValue.containsKey('data')) {
          throw Exception('PRIV frame value should be an object with keys id and data');
        }
        setPrivateFrame(frameValue['id'], frameValue['data']);
        break;
      default:
        throw Exception('Unsupported frame $frameName');
    }
    return this;
  }

  Uint8List addTag() {
    final BOM = [0xff, 0xfe];
    final headerSize = 10;
    final totalFrameSize = frames.fold(0, (sum, frame) => sum + (frame['size'] as int));
    final totalTagSize = headerSize + totalFrameSize + padding;
    final bufferWriter = Uint8List(arrayBuffer.lengthInBytes + totalTagSize);

    var offset = 0;
    var writeBytes = <int>[];

    writeBytes = [0x49, 0x44, 0x33, 3]; // ID3 tag and

    bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);

    offset += writeBytes.length;

    offset++; // version revision
    offset++; // flags

    writeBytes = Transform.uint28ToUint7Array(totalTagSize - headerSize); // tag size (without header)

    bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);

    offset += writeBytes.length;

    for (var frame in frames) {
      writeBytes = Encoder.encodeWindows1252(frame['name']);

      bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);

      offset += writeBytes.length;

      writeBytes = Transform.uint32ToUint8Array((frame['size'] as int) - headerSize);

      bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);

      offset += writeBytes.length;
      offset += 2; // flags

      final frameName = frame['name'] as String;
      switch (frameName) {
        case 'WCOM':
        case 'WCOP':
        case 'WOAF':
        case 'WOAR':
        case 'WOAS':
        case 'WORS':
        case 'WPAY':
        case 'WPUB':
          writeBytes = Encoder.encodeWindows1252(frame['value']); // URL
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;
          break;
        case 'TPE1':
        case 'TCOM':
        case 'TCON':
        case 'TLAN':
        case 'TIT1':
        case 'TIT2':
        case 'TIT3':
        case 'TALB':
        case 'TPE2':
        case 'TPE3':
        case 'TPE4':
        case 'TRCK':
        case 'TPOS':
        case 'TKEY':
        case 'TMED':
        case 'TPUB':
        case 'TCOP':
        case 'TEXT':
        case 'TSRC':
          writeBytes = [1, ...BOM]; // encoding, BOM
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;

          writeBytes = Encoder.encodeUtf16le(frame['value']); // frame value
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;
          break;
        case 'TXXX':
        case 'USLT':
        case 'COMM':
          writeBytes = [1]; // encoding
          if (frame['name'] == 'USLT' || frame['name'] == 'COMM') {
            writeBytes = [...writeBytes, ...frame['language']]; // language
          }
          writeBytes = [...writeBytes, ...BOM]; // BOM for content descriptor
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;

          writeBytes = Encoder.encodeUtf16le(frame['description']); // content descriptor
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;

          writeBytes = [0, 0, ...BOM]; // separator, BOM for frame value
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;

          writeBytes = Encoder.encodeUtf16le(frame['value']); // frame value
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;
          break;
        case 'TBPM':
        case 'TLEN':
        case 'TDAT':
        case 'TYER':
          offset++; // encoding

          writeBytes = Encoder.encodeWindows1252(frame['value'].toString()); // frame value
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;
          break;
        case 'PRIV':
          writeBytes = Encoder.encodeWindows1252(frame['id']); // identifier
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;

          offset++; // separator

          final List<int> frameValue = Uint8List.fromList(frame['value']);

          bufferWriter.setRange(offset, offset + frameValue.length, frameValue);
          offset += frameValue.length;

          break;
        case 'APIC':
          writeBytes = [frame['useUnicodeEncoding'] ? 1 : 0]; // encoding
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;

          writeBytes = Encoder.encodeWindows1252(frame['mimeType']); // MIME type
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;

          writeBytes = [0, frame['pictureType']]; // separator, pic type
          bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
          offset += writeBytes.length;

          if (frame['useUnicodeEncoding']) {
            writeBytes = [...BOM]; // BOM
            bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
            offset += writeBytes.length;

            writeBytes = Encoder.encodeUtf16le(frame['description']); // description
            bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
            offset += writeBytes.length;

            offset += 2; // separator
          } else {
            writeBytes = Encoder.encodeWindows1252(frame['description']); // description
            bufferWriter.setRange(offset, offset + writeBytes.length, writeBytes);
            offset += writeBytes.length;

            offset++; // separator
          }

          bufferWriter.setRange(offset, offset + (frame['value'].length as int), frame['value']); // picture content
          offset += frame['value'].length as int;
          break;
      }
    }

    offset += padding;
    bufferWriter.setRange(offset, offset + arrayBuffer.length, arrayBuffer);

    arrayBuffer = bufferWriter;
    return bufferWriter;
  }
}
