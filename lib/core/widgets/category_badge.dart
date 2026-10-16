import 'package:flutter/material.dart';

/// Індикатор категорії з кольоровою цяткою та назвою (віджет з core/widgets).
class CategoryBadge extends StatelessWidget {
  final String name;
  final Color color;

  const CategoryBadge({
    super.key,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
