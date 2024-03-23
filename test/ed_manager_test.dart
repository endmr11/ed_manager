import 'package:ed_manager/ed_manager.dart';
import 'package:test/test.dart';

void main() {
  group('Encode Decode Tests', () {
    late EncodeDecodeManager manager;
    Map<String, dynamic> dummyData = {};
    setUp(() {
      for (var i = 0; i < 17000; i++) {
        var a = {
          "$i": {
            "index": i,
            "height": 15.3,
            "age": 35,
            "name": "example",
            "description": "eren",
            "other1": [
              "e",
              "e",
              [99, true],
              {"e": DateTime.now().microsecondsSinceEpoch.toString()}
            ],
            "other2": {
              "a": 1,
              "b": 1.0,
              "c": "1",
              "d": [1.0, "ee", 127],
              "foo1": true,
              "foo2": false,
            },
          }
        };
        dummyData.addAll(a);
      }

      manager = EncodeDecodeManager(dummyData);
    });

    test('Encode Decode Test', () {
      var encoded = manager.encode();
      var decoded = manager.decode(encoded);
      print((decoded as Map).entries.last);
      expect(decoded, dummyData);
    });
  });
}
