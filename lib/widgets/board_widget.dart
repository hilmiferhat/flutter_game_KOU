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
      color: const Color(0xFF0F0F23),
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
    );
  }
}
