import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';

class HudWidget extends StatelessWidget {
  const HudWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return Container(
      color: const Color(0xFF16213E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoCard(
                label: 'HEDEF',
                value: controller.targetNumber != null
                    ? '${controller.targetNumber}'
                    : '?',
                valueColor: Colors.amber,
                large: true,
              ),
              _InfoCard(
                label: 'SKOR',
                value: '${controller.score}',
                valueColor: Colors.greenAccent,
              ),
              _InfoCard(
                label: 'YANLIŞ',
                value: '${controller.wrongMoves}/3',
                valueColor: controller.wrongMoves >= 2
                    ? Colors.redAccent
                    : Colors.white70,
              ),
              _InfoCard(
                label: 'HIZ',
                value: '${controller.dropIntervalSeconds}sn',
                valueColor: Colors.lightBlueAccent,
              ),
            ],
          ),
          if (controller.feedbackMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                controller.feedbackMessage!,
                style: TextStyle(
                  color: controller.feedbackMessage!.startsWith('+')
                      ? Colors.greenAccent
                      : Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool large;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.valueColor,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white54, fontSize: 10, letterSpacing: 1)),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: large ? 28 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
