import 'dart:convert';
import 'dart:typed_data';

import 'package:ed_manager/src/enum/data_type.dart';
import 'package:ed_manager/src/extension/data_type_extension.dart';

class EncodeDecodeManager {
  final Map<String, dynamic> data;

  EncodeDecodeManager(this.data);

  List<int> encode() {
    var byteBuffer = BytesBuilder();
    _encodeValue(data, byteBuffer);
    return byteBuffer.takeBytes();
  }

  void _encodeValue(dynamic value, BytesBuilder byteBuffer) {
    if (value is int) {
      byteBuffer.addByte(DataType.intType.marker);
      byteBuffer.add(intToVarint(value));
    } else if (value is double) {
      byteBuffer.addByte(DataType.doubleType.marker);
      var scaledIntBytes = doubleToScaledInt(value);
      byteBuffer.add(scaledIntBytes);
    } else if (value is String) {
      byteBuffer.addByte(DataType.stringType.marker);
      var bytes = utf8.encode(value);
      byteBuffer.add(intToVarint(bytes.length));
      byteBuffer.add(bytes);
    } else if (value is List) {
      byteBuffer.addByte(DataType.listType.marker);
      byteBuffer.add(intToVarint(value.length));
      for (var element in value) {
        _encodeValue(element, byteBuffer);
      }
    } else if (value is Map) {
      byteBuffer.addByte(DataType.mapType.marker);
      byteBuffer.add(intToVarint(value.length));
      value.forEach((key, val) {
        if (key is! String) throw FormatException("Incorrect key!");
        _encodeValue(key, byteBuffer);
        _encodeValue(val, byteBuffer);
      });
    } else if (value is bool) {
      byteBuffer.addByte(DataType.boolType.marker);
      byteBuffer.addByte(value ? 1 : 0);
    } else {
      throw FormatException("Unsupported type: ${value.runtimeType}");
    }
  }

  dynamic decode(List<int> encodedData) {
    var byteData = ByteData.sublistView(Uint8List.fromList(encodedData));
    int readPosition = 0;
    return _decodeValue(byteData, () => readPosition, (newPosition) => readPosition = newPosition);
  }

  dynamic _decodeValue(ByteData byteData, int Function() getPosition, Function(int) setPosition) {
    int position = getPosition();
    DataType dataType = DataTypeExtension.fromMarker(byteData.getUint8(position));
    position++;

    dynamic value;
    switch (dataType) {
      case DataType.intType:
        var result = varintToInt(byteData, position);
        value = result.value;
        position += result.bytesUsed;
        break;
      case DataType.doubleType:
        var intResult = varintToInt(byteData, position);
        value = scaledIntToDouble(intResult.value);
        position += intResult.bytesUsed;
        break;
      case DataType.stringType:
        var lengthResult = varintToInt(byteData, position);
        int length = lengthResult.value;
        position += lengthResult.bytesUsed;
        value = utf8.decode(byteData.buffer.asUint8List(position, length));
        position += length;
        break;
      case DataType.listType:
        var lengthResult = varintToInt(byteData, position);
        int length = lengthResult.value;
        position += lengthResult.bytesUsed;
        List<dynamic> list = [];
        for (int i = 0; i < length; i++) {
          var element = _decodeValue(byteData, () => position, (newPosition) => position = newPosition);
          list.add(element);
        }
        value = list;
        break;
      case DataType.mapType:
        var lengthResult = varintToInt(byteData, position);
        int length = lengthResult.value;
        position += lengthResult.bytesUsed;
        Map<String, dynamic> map = {};
        for (int i = 0; i < length; i++) {
          String key = _decodeValue(byteData, () => position, (newPosition) => position = newPosition);
          var val = _decodeValue(byteData, () => position, (newPosition) => position = newPosition);
          map[key] = val;
        }
        value = map;
        break;
      case DataType.boolType:
        value = byteData.getUint8(position) != 0;
        position += 1;
        break;
      default:
        throw FormatException("Incorrect Type");
    }

    setPosition(position);
    return value;
  }

  List<int> byteDataFromDouble(double value) {
    var buffer = ByteData(8);
    buffer.setFloat64(0, value, Endian.little);
    return buffer.buffer.asUint8List();
  }

  /// variable-length integer calculation
  List<int> intToVarint(int value) {
    List<int> bytes = [];
    while (value >= 128) {
      bytes.add((value & 127) | 128);
      value >>= 7;
    }
    bytes.add(value & 127);
    return bytes;
  }

  /// variable-length integer calculation
  VarintResult varintToInt(ByteData byteData, int position) {
    int value = 0;
    int shift = 0;
    int bytesRead = 0;
    while (true) {
      int byte = byteData.getUint8(position + bytesRead);
      bytesRead++;
      value |= (byte & 127) << shift;
      if ((byte & 128) == 0) {
        break;
      }
      shift += 7;
    }
    return VarintResult(value, bytesRead);
  }

  List<int> doubleToScaledInt(double value, {int scale = 1000}) {
    int scaledValue = (value * scale).round();
    return intToVarint(scaledValue);
  }

  double scaledIntToDouble(int scaledValue, {int scale = 1000}) {
    return scaledValue / scale;
  }
}

class VarintResult {
  final int value;
  final int bytesUsed;

  VarintResult(this.value, this.bytesUsed);
}
