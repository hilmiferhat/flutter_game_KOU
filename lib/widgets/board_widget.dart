import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'block_widget.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF110C18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A1F3A), width: 1),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF7B1FA2).withAlpha(15),
              blurRadius: 20,
              spreadRadius: 2),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: GameController.cols,
            childAspectRatio: 1.0,
          ),
          itemCount: GameController.rows * GameController.cols,
          itemBuilder: (context, index) {
            final row = index ~/ GameController.cols;
            final col = index % GameController.cols;
            final block = controller.board[row][col];

            return BlockWidget(
              block: block,
              onTap: () => controller.onBlockTap(row, col),
            );
          },
        ),
      ),
    );
  }
}
