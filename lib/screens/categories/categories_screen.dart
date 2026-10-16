import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/mock_data.dart';
import '../../models/category_model.dart';

/// Екран керування категоріями документів (FR8, Рис. 8 макетів).
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _newCategoryController =
      TextEditingController();
  Color _selectedColor = AppColors.categoryMedical;
  late List<CategoryModel> _categories;

  final List<Color> _availableColors = const [
    AppColors.categoryPersonal,
    AppColors.categoryTransport,
    AppColors.categoryFinance,
    AppColors.categoryEducation,
    AppColors.categoryHousing,
    AppColors.categoryMedical,
    Color(0xFF10B981), // смарагдовий
    Color(0xFF6366F1), // індиго
  ];

  @override
  void initState() {
    super.initState();
    _categories = List.from(MockData.categories);
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  void _handleAddCategory() {
    final name = _newCategoryController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вкажіть назву категорії!')),
      );
      return;
    }

    setState(() {
      _categories.add(
        CategoryModel(
          categoryId: 'cat_${DateTime.now().millisecondsSinceEpoch}',
          ownerId: 'usr_001',
          name: name,
          color: _selectedColor,
          documentCount: 0,
          createdAt: DateTime.now(),
        ),
      );
      _newCategoryController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Категорію «$name» успішно створено!'),
        backgroundColor: AppColors.statusActive,
      ),
    );
  }

  void _handleDeleteCategory(CategoryModel cat) {
    if (cat.documentCount > 0) {
      // Згідно з FR4/FR8: якщо категорія містить документи - система забороняє видалення
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Неможливо видалити категорію «${cat.name}», оскільки вона містить ${cat.documentCount} ${_pluralDocs(cat.documentCount)}!',
          ),
          backgroundColor: AppColors.statusExpired,
        ),
      );
      return;
    }

    setState(() {
      _categories.remove(cat);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Категорію «${cat.name}» видалено'),
        backgroundColor: AppColors.statusActive,
      ),
    );
  }

  String _pluralDocs(int count) {
    if (count % 10 == 1 && count % 100 != 11) return 'документ';
    if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return 'документи';
    }
    return 'документів';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 860;

    Widget listCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Наявні категорії',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: cat.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        cat.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${cat.documentCount} ${_pluralDocs(cat.documentCount)}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Редагувати',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Редагування категорії «${cat.name}»')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                      tooltip: 'Видалити',
                      onPressed: () => _handleDeleteCategory(cat),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    Widget addCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Нова категорія',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Назва',
            controller: _newCategoryController,
            hintText: 'Медичні',
          ),
          const SizedBox(height: 20),
          Text(
            'Колір',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: _availableColors.map((col) {
              final isSel = _selectedColor == col;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedColor = col;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: col,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSel ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSel
                        ? [
                            BoxShadow(
                              color: col.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: isSel
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          CustomButton(
            text: 'Додати категорію',
            icon: Icons.add,
            variant: ButtonVariant.primary,
            onPressed: _handleAddCategory,
          ),
        ],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Категорії',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 28),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: listCard),
                        const SizedBox(width: 24),
                        Expanded(flex: 4, child: addCard),
                      ],
                    )
                  : Column(
                      children: [
                        addCard,
                        const SizedBox(height: 20),
                        listCard,
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
