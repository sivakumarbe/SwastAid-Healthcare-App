import 'package:flutter/material.dart';
import '../core/theme/text_styles.dart';

class TileCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? color;

  const TileCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Standard tiles have black content on white background
    const Color textColor = Colors.black87;
    const double iconSize = 48;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: textColor),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.tileLabel.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
