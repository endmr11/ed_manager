import 'package:ed_manager/src/ed_manager_base.dart';

void main() {
  var manager = EncodeDecodeManager({
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
  });
  var encoded = manager.encode();
  var decoded = manager.decode(encoded);
  print(decoded);
}
