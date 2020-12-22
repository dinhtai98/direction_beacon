import 'dart:typed_data';

int byteToInt8(int b) =>
    new Uint8List.fromList([b]).buffer.asByteData().getInt8(0);

int twoByteToInt16(int v1, int v2) =>
    new Uint8List.fromList([v1, v2]).buffer.asByteData().getUint16(0);

String byteListToHexString(List<int> bytes) => bytes
    .map((i) => i.toRadixString(16).padLeft(2, '0'))
    .reduce((a, b) => (a + b));

String uRLPrefixFromByte(int schemeID) {
  switch (byteToInt8(schemeID)) {
    case 0x00:
      return "http://www.";
      break;
    case 0x01:
      return "https://www.";
      break;
    case 0x02:
      return "http://";
      break;
    case 0x03:
      return "https://";
      break;
    default:
      return null;
      break;
  }
}

String encodedStringFromByte(int charVal) {
  switch (byteToInt8(charVal)) {
    case 0x00:
      return ".com/";
      break;
    case 0x01:
      return ".org/";
      break;
    case 0x02:
      return ".edu/";
      break;
    case 0x03:
      return ".net/";
      break;
    case 0x04:
      return ".info/";
      break;
    case 0x05:
      return ".biz/";
      break;
    case 0x06:
      return ".gov/";
      break;
    case 0x07:
      return ".com";
      break;
    case 0x08:
      return ".org";
      break;
    case 0x09:
      return ".edu";
      break;
    case 0x0a:
      return ".net";
      break;
    case 0x0b:
      return ".info";
      break;
    case 0x0c:
      return ".biz";
      break;
    case 0x0d:
      return ".gov";
      break;
    default:
      return "";
    // return String(data: Data(bytes: [ charVal ] as [UInt8], count: 1), encoding: .utf8)
  }
}
