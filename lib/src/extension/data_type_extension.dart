import 'package:ed_manager/src/enum/data_type.dart';

extension DataTypeExtension on DataType {
  int get marker {
    switch (this) {
      case DataType.intType:
        return 0;
      case DataType.doubleType:
        return 1;
      case DataType.stringType:
        return 2;
      case DataType.listType:
        return 3;
      case DataType.mapType:
        return 4;
      case DataType.boolType:
        return 5;
      default:
        return -1;
    }
  }

  static DataType fromMarker(int marker) {
    switch (marker) {
      case 0:
        return DataType.intType;
      case 1:
        return DataType.doubleType;
      case 2:
        return DataType.stringType;
      case 3:
        return DataType.listType;
      case 4:
        return DataType.mapType;
      case 5:
        return DataType.boolType;
      default:
        throw FormatException("Incorrect Type: $marker");
    }
  }
}
