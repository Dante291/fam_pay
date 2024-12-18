import 'package:fam_assignment/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:fam_assignment/models/card.dart';
import 'package:fam_assignment/models/gradient.dart' as customgradient;

class DynamicWidthCard extends StatelessWidget {
  final cardWidget card;

  const DynamicWidthCard({
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: _buildGradient(card.bgGradient),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Background Image
            Image.network(
              card.bgImage?.imageUrl ?? '',
              fit: BoxFit.contain,
            ),
            // Gradient Overlay (if needed for blending)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: _buildGradient(card.bgGradient),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _buildGradient(customgradient.Gradient? bgGradient) {
    if (bgGradient == null || bgGradient.colors == null) {
      return const LinearGradient(
          colors: [Colors.transparent, Colors.transparent]);
    }

    return LinearGradient(
      colors: bgGradient.colors!.map((color) => color.toColor()).toList(),
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      transform: bgGradient.angle != null
          ? GradientRotation(bgGradient.angle! *
              (3.141592653589793 / 180)) // Convert angle to radians
          : null,
    );
  }
}
