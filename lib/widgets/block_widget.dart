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
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: const Color(0xFF160F20),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF2A1F3A), width: 0.5),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          gradient: block!.isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, block!.colorLight],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [block!.colorLight.withAlpha(120), block!.color],
                ),
          borderRadius: BorderRadius.circular(6),
          border: block!.isSelected
              ? Border.all(color: Colors.amber, width: 2.5)
              : Border.all(color: block!.color.withAlpha(80), width: 0.5),
          boxShadow: block!.isSelected
              ? [
                  BoxShadow(
                      color: Colors.amber.withAlpha(130),
                      blurRadius: 10,
                      spreadRadius: 1),
                  BoxShadow(
                      color: block!.color.withAlpha(100),
                      blurRadius: 6,
                      spreadRadius: 0),
                ]
              : [
                  BoxShadow(
                      color: block!.color.withAlpha(50),
                      blurRadius: 3,
                      offset: const Offset(0, 1)),
                ],
        ),
        child: Center(
          child: Text(
            '${block!.value}',
            style: TextStyle(
              color: block!.isSelected ? Colors.black87 : Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 17,
              shadows: block!.isSelected
                  ? null
                  : [
                      Shadow(
                          color: Colors.black.withAlpha(150),
                          blurRadius: 2,
                          offset: const Offset(0, 1)),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
