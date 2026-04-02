import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';

class HudWidget extends StatelessWidget {
  const HudWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1C1026), Color(0x001C1026)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sol: Skor
              _GlassCard(
                child: Column(
                  children: [
                    const Text('SKOR',
                        style: TextStyle(
                            color: Colors.white38,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2)),
                    const SizedBox(height: 2),
                    Text('${controller.score}',
                        style: const TextStyle(
                            color: Color(0xFFFFB74D),
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Orta: Hedef sayı (büyük daire)
              Expanded(
                child: Center(
                  child: _TargetCircle(
                    value: controller.targetNumber != null
                        ? '${controller.targetNumber}'
                        : '?',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Sağ: Yanlış + Hız
              Column(
                children: [
                  _GlassCard(
                    compact: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close,
                            size: 13,
                            color: controller.wrongMoves >= 2
                                ? const Color(0xFFEF5350)
                                : Colors.white38),
                        const SizedBox(width: 3),
                        Text('${controller.wrongMoves}/3',
                            style: TextStyle(
                                color: controller.wrongMoves >= 2
                                    ? const Color(0xFFEF5350)
                                    : Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  _GlassCard(
                    compact: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.speed,
                            size: 13, color: Color(0xFF80CBC4)),
                        const SizedBox(width: 3),
                        Text('${controller.dropIntervalSeconds}s',
                            style: const TextStyle(
                                color: Color(0xFF80CBC4),
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (controller.feedbackMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: controller.feedbackMessage!.startsWith('+')
                      ? const Color(0xFF66BB6A).withAlpha(40)
                      : const Color(0xFFFF7043).withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  controller.feedbackMessage!,
                  style: TextStyle(
                    color: controller.feedbackMessage!.startsWith('+')
                        ? const Color(0xFF81C784)
                        : const Color(0xFFFFAB91),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TargetCircle extends StatelessWidget {
  final String value;
  const _TargetCircle({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
        ),
        border: Border.all(color: const Color(0xFFCE93D8), width: 2),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFCE93D8).withAlpha(60),
              blurRadius: 12,
              spreadRadius: 1),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('HEDEF',
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final bool compact;
  const _GlassCard({required this.child, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withAlpha(20), width: 0.5),
      ),
      child: child,
    );
  }
}
