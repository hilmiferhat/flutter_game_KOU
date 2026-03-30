import 'dart:ui';
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
      backgroundColor: const Color(0xFF0D0A12),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const HudWidget(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: AspectRatio(
                      aspectRatio: GameController.cols / GameController.rows,
                      child: const BoardWidget(),
                    ),
                  ),
                ),
                _buildBottomBar(controller),
              ],
            ),
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
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x001C1026), Color(0xFF1C1026)],
        ),
        border: Border(
            top: BorderSide(color: Colors.white.withAlpha(10), width: 0.5)),
      ),
      child: Row(
        children: [
          // Seçim bilgisi — chip tarzı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: Colors.white.withAlpha(15), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedCount / 4 blok',
                  style:
                      const TextStyle(color: Colors.white38, fontSize: 10),
                ),
                const SizedBox(height: 1),
                Text(
                  'Toplam: $sum',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15),
                ),
              ],
            ),
          ),
          const Spacer(),
          // İptal butonu
          if (selectedCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white38,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.white.withAlpha(25)),
                  ),
                ),
                onPressed: controller.clearSelection,
                child: const Text('iPTAL',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          // Onayla butonu — pill shape
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedCount >= 2
                    ? const Color(0xFFFFB74D)
                    : Colors.white.withAlpha(15),
                foregroundColor:
                    selectedCount >= 2 ? const Color(0xFF1C1026) : Colors.white24,
                elevation: selectedCount >= 2 ? 4 : 0,
                shadowColor: const Color(0xFFFFB74D).withAlpha(80),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: selectedCount >= 2 ? controller.onConfirm : null,
              child: const Text('ONAYLA',
                  style:
                      TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(GameController controller) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        color: const Color(0xFF0D0A12).withAlpha(200),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2A1040), Color(0xFF1C1026)],
              ),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: const Color(0xFFCE93D8).withAlpha(60), width: 1),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF7B1FA2).withAlpha(40),
                    blurRadius: 30,
                    spreadRadius: 5),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'OYUN BiTTi',
                  style: TextStyle(
                    color: Color(0xFFEF5350),
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text('SKOR',
                          style: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.score}',
                        style: const TextStyle(
                            color: Color(0xFFFFB74D),
                            fontSize: 36,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB74D),
                    foregroundColor: const Color(0xFF1C1026),
                    elevation: 4,
                    shadowColor: const Color(0xFFFFB74D).withAlpha(80),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => controller.initGame(),
                  child: const Text('YENiDEN OYNA',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
