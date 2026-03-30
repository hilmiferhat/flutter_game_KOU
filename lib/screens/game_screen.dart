import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/board_widget.dart';
import '../widgets/hud_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameController>().initGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // HUD
                const HudWidget(),
                // Oyun alanı (8x10 grid, ekrana sığdır)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AspectRatio(
                      aspectRatio: GameController.cols / GameController.rows,
                      child: const BoardWidget(),
                    ),
                  ),
                ),
                // Alt kontrol alanı
                _buildBottomBar(controller),
              ],
            ),
            // Oyun sonu overlay
            if (controller.isGameOver) _buildGameOverOverlay(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(GameController controller) {
    final selectedCount = controller.selectedPositions.length;
    final sum = controller.selectedPositions.fold<int>(
      0,
      (s, p) => s + (controller.board[p[0]][p[1]]?.value ?? 0),
    );

    return Container(
      color: const Color(0xFF16213E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Seçim bilgisi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedCount blok seçili (max 4)',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                Text(
                  'Toplam: $sum',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // İptal butonu
          if (selectedCount > 0)
            TextButton(
              onPressed: controller.clearSelection,
              child: const Text('İPTAL', style: TextStyle(color: Colors.grey)),
            ),
          const SizedBox(width: 8),
          // Onayla butonu
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedCount >= 2 ? Colors.greenAccent : Colors.grey,
              foregroundColor: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: selectedCount >= 2 ? controller.onConfirm : null,
            child: const Text('ONAYLA',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(GameController controller) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'OYUN BİTTİ',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Skorunuz: ${controller.score}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => controller.initGame(),
                child: const Text('YENİDEN OYNA',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
