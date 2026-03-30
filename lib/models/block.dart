import 'package:flutter/material.dart';

const Map<int, Color> blockColors = {
  1: Color(0xFFEF5350), // Mercan
  2: Color(0xFFFF7043), // Turuncu
  3: Color(0xFFFFCA28), // Altın
  4: Color(0xFF66BB6A), // Zümrüt
  5: Color(0xFF26C6DA), // Turkuaz
  6: Color(0xFF42A5F5), // Gök mavi
  7: Color(0xFFAB47BC), // Ametist
  8: Color(0xFFEC407A), // Fuşya
  9: Color(0xFF8D6E63), // Bronz
};

const Map<int, Color> blockColorsLight = {
  1: Color(0xFFFFCDD2),
  2: Color(0xFFFFCCBC),
  3: Color(0xFFFFF9C4),
  4: Color(0xFFC8E6C9),
  5: Color(0xFFB2EBF2),
  6: Color(0xFFBBDEFB),
  7: Color(0xFFE1BEE7),
  8: Color(0xFFF8BBD0),
  9: Color(0xFFD7CCC8),
};

const Map<int, int> pointValues = {
  1: 1,
  2: 2,
  3: 3,
  4: 5,
  5: 7,
  6: 9,
  7: 12,
  8: 15,
  9: 20,
};

class Block {
  final int value;
  bool isSelected;

  Block({required this.value, this.isSelected = false});

  Color get color => blockColors[value]!;
  Color get colorLight => blockColorsLight[value]!;
  int get points => pointValues[value]!;

  Block copyWith({int? value, bool? isSelected}) {
    return Block(
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
