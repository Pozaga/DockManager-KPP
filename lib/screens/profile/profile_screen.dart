import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/mock_data.dart';
import '../auth/login_screen.dart';
import 'change_password_screen.dart';

/// Екран керування профілем користувача (FR10, Рис. 9 макетів).
class ProfileScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeModeChanged;
  final ThemeMode currentThemeMode;

  const ProfileScreen({
    super.key,
    this.onThemeModeChanged,
    this.currentThemeMode = ThemeMode.light,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late String _selectedTheme;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: MockData.currentUser.displayName);
    _emailController =
        TextEditingController(text: MockData.currentUser.email);

    if (widget.currentThemeMode == ThemeMode.dark) {
      _selectedTheme = 'dark';
    } else if (widget.currentThemeMode == ThemeMode.light) {
      _selectedTheme = 'light';
    } else {
      _selectedTheme = 'system';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSaveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Профіль успішно оновлено!'),
        backgroundColor: AppColors.statusActive,
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вийти з акаунта?'),
        content: const Text('Ви впевнені, що бажаєте вийти з облікового запису?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusExpired),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Вийти', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 800;

    Widget avatarSection = Column(
      children: [
        CircleAvatar(
          radius: 54,
          backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
          child: Text(
            MockData.currentUser.displayName.isNotEmpty
                ? MockData.currentUser.displayName[0]
                : 'U',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          MockData.currentUser.displayName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          MockData.currentUser.email,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Вибір зображення профілю')),
            );
          },
          icon: const Icon(Icons.camera_alt_outlined, size: 18),
          label: const Text('Змінити фото'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
      ],
    );

    Widget formSection = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          label: 'Ім\'я',
          controller: _nameController,
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Електронна пошта',
          controller: _emailController,
          readOnly: true,
          prefixIcon: Icons.email_outlined,
          helperText: 'Пошту змінити не можна',
        ),
        const SizedBox(height: 24),
        Text(
          'Тема оформлення',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'light',
              label: Text('Світла'),
              icon: Icon(Icons.light_mode_outlined, size: 16),
            ),
            ButtonSegment(
              value: 'dark',
              label: Text('Темна'),
              icon: Icon(Icons.dark_mode_outlined, size: 16),
            ),
            ButtonSegment(
              value: 'system',
              label: Text('Системна'),
              icon: Icon(Icons.settings_brightness_outlined, size: 16),
            ),
          ],
          selected: {_selectedTheme},
          onSelectionChanged: (newSelection) {
            final val = newSelection.first;
            setState(() {
              _selectedTheme = val;
            });
            if (widget.onThemeModeChanged != null) {
              if (val == 'light') {
                widget.onThemeModeChanged!(ThemeMode.light);
              } else if (val == 'dark') {
                widget.onThemeModeChanged!(ThemeMode.dark);
              } else {
                widget.onThemeModeChanged!(ThemeMode.system);
              }
            }
          },
        ),
        const SizedBox(height: 28),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: ListTile(
            leading: const Icon(Icons.lock_outline, color: AppColors.primary),
            title: const Text(
              'Змінити пароль',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Зберегти зміни',
                variant: ButtonVariant.primary,
                onPressed: _handleSaveProfile,
              ),
            ),
            const SizedBox(width: 12),
            CustomButton(
              text: 'Вийти',
              variant: ButtonVariant.danger,
              icon: Icons.logout,
              onPressed: _handleLogout,
            ),
          ],
        ),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Профіль користувача',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4, child: avatarSection),
                          Container(
                            width: 1,
                            height: 340,
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                          Expanded(flex: 6, child: formSection),
                        ],
                      )
                    : Column(
                        children: [
                          avatarSection,
                          const SizedBox(height: 32),
                          const Divider(),
                          const SizedBox(height: 24),
                          formSection,
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
