## Overview

Encoding and decoding processes involve converting data structures into byte arrays and reconstructing the original data structures from these byte arrays. These processes ensure efficiency and compatibility during data storage and transmission. In Dart, classes such as ByteData, Uint8List, and BytesBuilder are utilized for these operations.

## Adım 1: Data Type Markers

We designated a unique marker for each data type. This marker is used to identify the data type during decoding. For instance, before encoding an integer value, we add a marker indicating that this value is an integer.

## Adım 2: Data Encoding

During the encoding process, a different encoding method is applied for each data type:

- Integer: Encoded using Varint(variable-length integer) encoding to occupy less space. This increases efficiency, especially for large numbers.
- Double: Scaled by multiplying it with a predetermined scale factor, then the result is encoded as an integer. This method allows encoding double values as varint, but there can be a loss of precision.
- String: Converted into a byte array using UTF-8 encoding. The length of the string is encoded as varint, followed by the string bytes.
- List ve Map: Structures are iterated through, encoding each element sequentially. The lengths of these collections are also encoded as varint.
- Bool: Encoded as 1 or 0, representing the boolean value true or false, respectively.

## Adım 3: Data Decoding

The decoding process involves reconstructing the original data structure from the encoded byte array. During decoding, the appropriate decoding method is selected based on the marker for each data type::

- Integer ve Double: Values encoded as varint are decoded. For doubles, the decoded integer value is divided by the scale factor to obtain the original double value.
- String: First, the length of the string is decoded, then bytes of this length are read and converted back to the original string using UTF-8 decoding.
- List ve Map: After their lengths are decoded, elements are decoded sequentially to reconstruct the original structure.
- Bool: Decoded as false if 0, and true if 1.

## Varint(variable-length integer)
A variable-length integer is a method used to encode integers using a varying number of bytes depending on the size of the number. This encoding method is especially used in data compression and efficient data storage/transfer scenarios. Variable-length integers typically represent smaller numbers with fewer bytes and larger numbers with more bytes, thus allowing a wide range of integer values to be encoded dynamically and with space efficiency. For example: Google Protobuf

## Conclusion

These processes are optimized for efficient data storage and transmission. Scaling and encoding double values as varint allow for efficient storage of this data type, though there can be a loss of precision depending on the scale factor used. Therefore, it is important to select the scale factor according to the requirements..
