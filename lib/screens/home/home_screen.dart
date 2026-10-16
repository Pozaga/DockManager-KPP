import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/category_badge.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';
import '../../models/document_model.dart';
import '../documents/delete_confirmation_dialog.dart';
import '../documents/document_detail_screen.dart';
import '../documents/document_form_screen.dart';

/// Головний екран: зведення, список документів, пошук і фільтрація (FR4, Рис. 4 макетів).
/// Реалізовано відповідно до вимог Лабораторної роботи №3.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Згідно з завданням 4.2 лабораторної роботи:
  // "Замість реальних даних користувача із віддаленого сервера можна використати hardcoded-дані:
  //  статична змінна із іменем користувача static const String _userName = '...' для відображення"
  static const String _userName = 'Олена Ковальчук';

  final TextEditingController _searchController = TextEditingController();
  late List<DocumentModel> _allDocuments;

  String _searchQuery = '';
  String _selectedCategory = 'all';
  DocumentStatus? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    _allDocuments = List.from(MockData.documents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Обчислення лічильників зведення (FR4)
  int get _totalCount => _allDocuments.length;
  int get _expiringCount =>
      _allDocuments.where((d) => d.status == DocumentStatus.expiring).length;
  int get _expiredCount =>
      _allDocuments.where((d) => d.status == DocumentStatus.expired).length;

  List<DocumentModel> get _filteredDocuments {
    return _allDocuments.where((doc) {
      // Фільтр пошуку
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = doc.title.toLowerCase().contains(query);
        final matchNumber = doc.number?.toLowerCase().contains(query) ?? false;
        final matchIssuer = doc.issuer?.toLowerCase().contains(query) ?? false;
        if (!matchTitle && !matchNumber && !matchIssuer) return false;
      }

      // Фільтр категорії
      if (_selectedCategory != 'all' && doc.categoryName != _selectedCategory) {
        return false;
      }

      // Фільтр статусу
      if (_selectedStatusFilter != null && doc.status != _selectedStatusFilter) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        // За специфікацією: сортування за терміном дії (прострочені й ті, що спливають, вище)
        if (a.expiryDate == null && b.expiryDate == null) return 0;
        if (a.expiryDate == null) return 1;
        if (b.expiryDate == null) return -1;
        return a.expiryDate!.compareTo(b.expiryDate!);
      });
  }

  void _openCreateDocument() async {
    final newDoc = await Navigator.of(context).push<DocumentModel>(
      MaterialPageRoute(builder: (context) => const DocumentFormScreen()),
    );

    if (newDoc != null) {
      setState(() {
        _allDocuments.insert(0, newDoc);
      });
    }
  }

  void _openDocumentDetails(DocumentModel doc) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentDetailScreen(
          document: doc,
          onDocumentChanged: () => setState(() {}),
        ),
      ),
    );
  }

  void _openEditDocument(DocumentModel doc) async {
    final updated = await Navigator.of(context).push<DocumentModel>(
      MaterialPageRoute(builder: (context) => DocumentFormScreen(document: doc)),
    );

    if (updated != null) {
      setState(() {
        final idx = _allDocuments.indexWhere((d) => d.documentId == doc.documentId);
        if (idx != -1) {
          _allDocuments[idx] = updated;
        }
      });
    }
  }

  void _deleteDocument(DocumentModel doc) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        documentTitle: doc.title,
        onConfirm: () {
          setState(() {
            _allDocuments.removeWhere((d) => d.documentId == doc.documentId);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Документ «${doc.title}» видалено'),
              backgroundColor: AppColors.statusActive,
            ),
          );
        },
      ),
    );
  }

  Color _getCategoryColor(String catName) {
    switch (catName) {
      case 'Особисті':
        return AppColors.categoryPersonal;
      case 'Транспорт':
        return AppColors.categoryTransport;
      case 'Фінанси':
        return AppColors.categoryFinance;
      case 'Освіта':
        return AppColors.categoryEducation;
      case 'Житло':
        return AppColors.categoryHousing;
      default:
        return AppColors.categoryMedical;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 768;
    final documents = _filteredDocuments;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Верхній рядок: Заголовок "Головна" та кнопка "+ Додати документ"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Головна',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Вітаємо, $_userName',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    text: 'Додати документ',
                    icon: Icons.add,
                    variant: ButtonVariant.primary,
                    onPressed: _openCreateDocument,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Лічильники зведення статусів
              Row(
                children: [
                  StatCard(
                    title: 'Усього',
                    count: _totalCount,
                    isSelected: _selectedStatusFilter == null,
                    onTap: () {
                      setState(() {
                        _selectedStatusFilter = null;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  StatCard(
                    title: 'Спливають скоро',
                    count: _expiringCount,
                    accentColor: AppColors.statusExpiring,
                    isSelected: _selectedStatusFilter == DocumentStatus.expiring,
                    onTap: () {
                      setState(() {
                        _selectedStatusFilter =
                            _selectedStatusFilter == DocumentStatus.expiring
                                ? null
                                : DocumentStatus.expiring;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  StatCard(
                    title: 'Прострочені',
                    count: _expiredCount,
                    accentColor: AppColors.statusExpired,
                    isSelected: _selectedStatusFilter == DocumentStatus.expired,
                    onTap: () {
                      setState(() {
                        _selectedStatusFilter =
                            _selectedStatusFilter == DocumentStatus.expired
                                ? null
                                : DocumentStatus.expired;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Панель пошуку та фільтрів
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Пошук документів...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          isDense: true,
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Вибір категорії
                    SizedBox(
                      width: 170,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('Всі категорії')),
                          DropdownMenuItem(value: 'Особисті', child: Text('Особисті')),
                          DropdownMenuItem(value: 'Транспорт', child: Text('Транспорт')),
                          DropdownMenuItem(value: 'Фінанси', child: Text('Фінанси')),
                          DropdownMenuItem(value: 'Освіта', child: Text('Освіта')),
                          DropdownMenuItem(value: 'Житло', child: Text('Житло')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedCategory = val;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Вибір статусу
                    SizedBox(
                      width: 180,
                      child: DropdownButtonFormField<DocumentStatus?>(
                        initialValue: _selectedStatusFilter,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('Всі статуси')),
                          DropdownMenuItem(value: DocumentStatus.active, child: Text('Дійсні')),
                          DropdownMenuItem(value: DocumentStatus.expiring, child: Text('Спливають скоро')),
                          DropdownMenuItem(value: DocumentStatus.expired, child: Text('Прострочені')),
                          DropdownMenuItem(value: DocumentStatus.permanent, child: Text('Безстрокові')),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _selectedStatusFilter = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Таблиця документів (FR4, Рис. 4)
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: documents.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_outlined,
                                size: 48,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Нічого не знайдено',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Спробуйте змінити фільтри або пошуковий запит',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                text: 'Скинути фільтри',
                                variant: ButtonVariant.secondary,
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                    _selectedCategory = 'all';
                                    _selectedStatusFilter = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          // Заголовки таблиці
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                ),
                              ),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(width: 8),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Назва',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMutedLight),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Категорія',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMutedLight),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Дійсний до',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMutedLight),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Статус',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMutedLight),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Файли',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMutedLight),
                                  ),
                                ),
                                SizedBox(width: 44),
                              ],
                            ),
                          ),
                          // Рядки документів
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: documents.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                            itemBuilder: (context, index) {
                              final doc = documents[index];
                              return InkWell(
                                onTap: () => _openDocumentDetails(doc),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.description_outlined, size: 20, color: AppColors.primary),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          doc.title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: CategoryBadge(
                                          name: doc.categoryName,
                                          color: _getCategoryColor(doc.categoryName),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          doc.formattedExpiryDate,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: StatusBadge(status: doc.status),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Row(
                                          children: [
                                            const Icon(Icons.attach_file, size: 16, color: AppColors.textMutedLight),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${doc.attachments.length}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert, size: 20),
                                        tooltip: 'Дії з документом',
                                        onSelected: (action) {
                                          if (action == 'open') {
                                            _openDocumentDetails(doc);
                                          } else if (action == 'edit') {
                                            _openEditDocument(doc);
                                          } else if (action == 'delete') {
                                            _deleteDocument(doc);
                                          }
                                        },
                                        itemBuilder: (context) => const [
                                          PopupMenuItem(
                                            value: 'open',
                                            child: Row(
                                              children: [
                                                Icon(Icons.visibility_outlined, size: 18),
                                                SizedBox(width: 10),
                                                Text('Відкрити'),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit_outlined, size: 18),
                                                SizedBox(width: 10),
                                                Text('Редагувати'),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                                SizedBox(width: 10),
                                                Text('Видалити', style: TextStyle(color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
