import 'package:flutter/material.dart';

/// Кольорова палітра застосунку DocKeeper (згідно з макетами Лаб 2).
class AppColors {
  AppColors._();

  // Основні брендові кольори (індиго/синій)
  static const Color primary = Color(0xFF2E4ECB);
  static const Color primaryLight = Color(0xFF4C6EF5);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color sidebarBackground = Color(0xFF1E2843);
  static const Color sidebarActiveItem = Color(0xFF2E4ECB);

  // Світла тема
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // Темна тема
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Статуси документів (згідно зі специфікацією та макетами Лаб 2)
  // Дійсний (зелений)
  static const Color statusActive = Color(0xFF2E7D32);
  static const Color statusActiveBg = Color(0xFFE8F5E9);

  // Спливає скоро (жовтий / бурштиновий)
  static const Color statusExpiring = Color(0xFFF57F17);
  static const Color statusExpiringBg = Color(0xFFFFF8E1);

  // Прострочений (червоний)
  static const Color statusExpired = Color(0xFFC62828);
  static const Color statusExpiredBg = Color(0xFFFFEBEE);

  // Безстроковий (сірий / нейтральний)
  static const Color statusPermanent = Color(0xFF616161);
  static const Color statusPermanentBg = Color(0xFFF5F5F5);

  // Кольори категорій
  static const Color categoryPersonal = Color(0xFF2E4ECB); // Особисті (синій)
  static const Color categoryTransport = Color(0xFF0284C7); // Транспорт (блакитний)
  static const Color categoryFinance = Color(0xFF7C3AED); // Фінанси (фіолетовий)
  static const Color categoryEducation = Color(0xFFEA580C); // Освіта (помаранчевий)
  static const Color categoryHousing = Color(0xFFEAB308); // Житло (жовтий)
  static const Color categoryMedical = Color(0xFFE11D48); // Медичні (малиновий)
}
