import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum DocumentStatus {
  active,
  expiring,
  expired,
  permanent,
}

/// Бейдж статусу документа (віджет з пакету core/widgets).
/// Відображає статус за допомогою фону, іконки та локалізованого тексту.
class StatusBadge extends StatelessWidget {
  final DocumentStatus status;
  final String? customLabel;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (status) {
      case DocumentStatus.active:
        bg = AppColors.statusActiveBg;
        fg = AppColors.statusActive;
        icon = Icons.check_circle_outline;
        label = 'Дійсний';
        break;
      case DocumentStatus.expiring:
        bg = AppColors.statusExpiringBg;
        fg = AppColors.statusExpiring;
        icon = Icons.warning_amber_rounded;
        label = 'Спливає скоро';
        break;
      case DocumentStatus.expired:
        bg = AppColors.statusExpiredBg;
        fg = AppColors.statusExpired;
        icon = Icons.error_outline_rounded;
        label = 'Прострочений';
        break;
      case DocumentStatus.permanent:
        bg = AppColors.statusPermanentBg;
        fg = AppColors.statusPermanent;
        icon = Icons.all_inclusive;
        label = 'Безстроковий';
        break;
    }

    if (customLabel != null) {
      label = customLabel!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
