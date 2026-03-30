import 'package:flutter/material.dart';
import '../models/block.dart';

class BlockWidget extends StatelessWidget {
  final Block? block;
  final VoidCallback? onTap;

  const BlockWidget({super.key, this.block, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (block == null) {
      return Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: block!.isSelected ? Colors.white : block!.color,
          borderRadius: BorderRadius.circular(4),
          border: block!.isSelected
              ? Border.all(color: block!.color, width: 3)
              : Border.all(color: Colors.black26, width: 1),
          boxShadow: block!.isSelected
              ? [BoxShadow(color: block!.color.withAlpha(180), blurRadius: 8, spreadRadius: 2)]
              : null,
        ),
        child: Center(
          child: Text(
            '${block!.value}',
            style: TextStyle(
              color: block!.isSelected ? block!.color : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
