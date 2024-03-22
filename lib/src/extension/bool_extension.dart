extension BoolExtension on bool {
  int get toInt => this == true ? 1 : 0;
}