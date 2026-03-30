import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'block_widget.dart';

class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  final GlobalKey _gridKey = GlobalKey();

  // Track last cell dragged over to avoid re-triggering the same cell
  int? _lastDragRow;
  int? _lastDragCol;

  List<int>? _cellAt(Offset localPosition) {
    final box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;

    final cellWidth = box.size.width / GameController.cols;
    final cellHeight = box.size.height / GameController.rows;

    final col = (localPosition.dx / cellWidth).floor();
    final row = (localPosition.dy / cellHeight).floor();

    if (row < 0 || row >= GameController.rows) return null;
    if (col < 0 || col >= GameController.cols) return null;

    return [row, col];
  }

  void _handlePanStart(DragStartDetails details, GameController controller) {
    final box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(details.globalPosition);
    final cell = _cellAt(local);
    if (cell == null) return;

    _lastDragRow = cell[0];
    _lastDragCol = cell[1];
    controller.onBlockTap(cell[0], cell[1]);
  }

  void _handlePanUpdate(DragUpdateDetails details, GameController controller) {
    final box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(details.globalPosition);
    final cell = _cellAt(local);
    if (cell == null) return;

    // Only trigger if we've moved to a new cell
    if (cell[0] == _lastDragRow && cell[1] == _lastDragCol) return;

    _lastDragRow = cell[0];
    _lastDragCol = cell[1];
    controller.onBlockTap(cell[0], cell[1]);
  }

  void _handlePanEnd(DragEndDetails details) {
    _lastDragRow = null;
    _lastDragCol = null;
    // Selection remains; user confirms via the ONAYLA button
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return GestureDetector(
      onPanStart: (d) => _handlePanStart(d, controller),
      onPanUpdate: (d) => _handlePanUpdate(d, controller),
      onPanEnd: _handlePanEnd,
      child: Container(
        key: _gridKey,
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
      ),
    );
  }
}
