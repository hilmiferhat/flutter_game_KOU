import 'package:flutter/material.dart';

const Map<int, Color> blockColors = {
  1: Color(0xFFE53935), // Kırmızı
  2: Color(0xFFFB8C00), // Turuncu
  3: Color(0xFFFDD835), // Sarı
  4: Color(0xFF43A047), // Yeşil
  5: Color(0xFF00ACC1), // Cyan
  6: Color(0xFF1E88E5), // Mavi
  7: Color(0xFF8E24AA), // Mor
  8: Color(0xFFE91E63), // Pembe
  9: Color(0xFF6D4C41), // Kahverengi
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
  int get points => pointValues[value]!;

  Block copyWith({int? value, bool? isSelected}) {
    return Block(
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
