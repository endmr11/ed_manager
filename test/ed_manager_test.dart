import 'package:ed_manager/ed_manager.dart';
import 'package:test/test.dart';

void main() {
  group('Encode Decode Tests', () {
    late Map<String, dynamic> dummyData;
    late EncodeDecodeManager manager;

    setUp(() {
      dummyData = {
        "height": 15.3,
        "age": 3500,
        "name": "example",
        "description": "eren",
        "other1": [
          "e",
          "e",
          [99, true],
          {"e": 13}
        ],
        "other2": {
          "a": 1,
          "b": 1.0,
          "c": "1",
          "d": [1.0, "ee", 300],
          "foo1": true,
          "foo2": false,
        },
      };
      manager = EncodeDecodeManager(dummyData);
    });

    test('Encode Decode Test', () {
      var encoded = manager.encode();
      var decoded = manager.decode(encoded);
      print(decoded);
      expect(decoded, dummyData);
    });
  });
}
