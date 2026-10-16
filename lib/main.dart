import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DocKeeperApp());
}

/// Головний клас Flutter застосунку DocKeeper.
/// Розроблено для Лабораторної роботи №3 з дисципліни "Кросплатформне програмування".
/// Студент: Новосельський Анатолій (гр. ПЗ-32).
class DocKeeperApp extends StatefulWidget {
  const DocKeeperApp({super.key});

  @override
  State<DocKeeperApp> createState() => _DocKeeperAppState();
}

class _DocKeeperAppState extends State<DocKeeperApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _updateThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocKeeper - Менеджер особистих документів',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      // Початковий екран авторизації (FR2)
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => MainLayout(
              currentThemeMode: _themeMode,
              onThemeModeChanged: _updateThemeMode,
            ),
      },
    );
  }
}
