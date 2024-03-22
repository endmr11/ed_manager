import 'dart:convert';
import 'dart:typed_data';

import 'package:ed_manager/src/enum/data_type.dart';
import 'package:ed_manager/src/extension/bool_extension.dart';
import 'package:ed_manager/src/extension/data_type_extension.dart';
import 'package:ed_manager/src/extension/int_extension.dart';

final class EncodeDecodeManager {
  final Map<String, dynamic> data;

  EncodeDecodeManager(this.data);

  /// The [encode] method returns you a List<int> value by separating the Map type [data] object you provide from outside into bytes.
  List<int> encode() {
    var byteBuffer = BytesBuilder();
    _encodeValue(data, byteBuffer);
    return byteBuffer.takeBytes();
  }

  void _encodeValue(dynamic value, BytesBuilder byteBuffer) {
    if (value is int) {
      byteBuffer.addByte(DataType.intType.marker);
      byteBuffer.add(byteDataFromInt(value));
    } else if (value is double) {
      byteBuffer.addByte(DataType.doubleType.marker);
      byteBuffer.add(byteDataFromDouble(value));
    } else if (value is String) {
      byteBuffer.addByte(DataType.stringType.marker);
      var bytes = utf8.encode(value);
      byteBuffer.add(byteDataFromInt(bytes.length));
      byteBuffer.add(bytes);
    } else if (value is List) {
      byteBuffer.addByte(DataType.listType.marker);
      byteBuffer.add(byteDataFromInt(value.length));
      for (var element in value) {
        _encodeValue(element, byteBuffer);
      }
    } else if (value is Map) {
      byteBuffer.addByte(DataType.mapType.marker);
      byteBuffer.add(byteDataFromInt(value.length));
      value.forEach((key, val) {
        if (key is! String) {
          throw FormatException("Incorrect key!");
        }
        _encodeValue(key, byteBuffer);
        _encodeValue(val, byteBuffer);
      });
    } else if (value is bool) {
      byteBuffer.addByte(DataType.boolType.marker);
      byteBuffer.add(byteDataFromInt(value.toInt));
    } else {
      throw FormatException("Incorrect key: ${value.runtimeType}");
    }
  }

  /// The [decode] method divides the List<int> type [encodedData] object you provide externally into bytes, decodes them and returns the appropriate values ​​to you.
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
        value = byteData.getInt32(position, Endian.little);
        position += 4;
        break;
      case DataType.doubleType:
        value = byteData.getFloat64(position, Endian.little);
        position += 8;
        break;
      case DataType.stringType:
        int length = byteData.getInt32(position, Endian.little);
        position += 4;
        value = utf8.decode(byteData.buffer.asUint8List(position, length));
        position += length;
        break;
      case DataType.listType:
        int length = byteData.getInt32(position, Endian.little);
        position += 4;
        List<dynamic> list = [];
        for (int i = 0; i < length; i++) {
          var element = _decodeValue(byteData, () => position, (newPosition) => position = newPosition);
          list.add(element);
        }
        value = list;
        break;
      case DataType.mapType:
        int length = byteData.getInt32(position, Endian.little);
        position += 4;
        Map<String, dynamic> map = {};
        for (int i = 0; i < length; i++) {
          String key = _decodeValue(byteData, () => position, (newPosition) => position = newPosition);
          var val = _decodeValue(byteData, () => position, (newPosition) => position = newPosition);
          map[key] = val;
        }
        value = map;
        break;
      case DataType.boolType:
        value = byteData.getInt32(position, Endian.little).toBool;
        position += 4;
        break;
      default:
        throw FormatException("Incorrect Type");
    }

    setPosition(position);
    return value;
  }

  List<int> byteDataFromInt(int value) {
    var buffer = ByteData(4);
    buffer.setInt32(0, value, Endian.little);
    return buffer.buffer.asUint8List();
  }

  List<int> byteDataFromDouble(double value) {
    var buffer = ByteData(8);
    buffer.setFloat64(0, value, Endian.little);
    return buffer.buffer.asUint8List();
  }
}
