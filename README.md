# ED Manager

ED Manager is a Dart package designed to efficiently encode and decode complex data structures into a compact binary format. This utility is particularly useful for applications that need to serialize and deserialize data with high performance and minimal footprint, such as data storage, network transmission, and inter-process communication.

[![pubdev](https://img.shields.io/badge/pub-ed_manager-blue)](https://pub.dev/packages/ed_manager)

## Features

- Data Types Support: Handles common data types including int, double, String, bool, List, and Map.

- Compact Encoding: Utilizes a compact binary representation to save space.

- Extensible: Easily extendible to support more data types as needed.

- Endian-Agnostic: Supports little endian byte order for cross-platform compatibility.

## Installation

To use ED Manager in your Dart project, add it to your project's pubspec.yaml file under dependencies:

```
  dependencies:
    ed_manager: <latest_version>
```

Then, run the following command to install the package:

```
  dart pub get
```

## Usage

```dart
import 'package:ed_manager/ed_manager.dart';

final data = {
  'name': 'John Doe',
  'age': 30,
  'isDeveloper': true,
  'skills': ['Dart', 'Flutter', 'JavaScript']
};

final encoder = EncodeDecodeManager(data);
List<int> encodedData = encoder.encode();
final decodedData = EncodeDecodeManager.decode(encodedData);
print(decodedData);
```

## Contributors

Author: endmr11 [!["github"](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/endmr11)

## Feedback

If you have any feedback, please contact us at erndemir.1@gmail.com.
