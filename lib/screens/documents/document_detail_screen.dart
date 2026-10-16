import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/document_model.dart';
import 'delete_confirmation_dialog.dart';
import 'document_form_screen.dart';

/// Екран перегляду деталей документа та його електронних копій (FR6, FR9, Рис. 6 макетів).
class DocumentDetailScreen extends StatefulWidget {
  final DocumentModel document;
  final VoidCallback? onDocumentChanged;

  const DocumentDetailScreen({
    super.key,
    required this.document,
    this.onDocumentChanged,
  });

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  late DocumentModel _doc;

  @override
  void initState() {
    super.initState();
    _doc = widget.document;
  }

  void _handleEdit() async {
    final result = await Navigator.of(context).push<DocumentModel>(
      MaterialPageRoute(
        builder: (context) => DocumentFormScreen(document: _doc),
      ),
    );

    if (result != null) {
      setState(() {
        _doc = result;
      });
      widget.onDocumentChanged?.call();
    }
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        documentTitle: _doc.title,
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Документ «${_doc.title}» видалено'),
              backgroundColor: AppColors.statusActive,
            ),
          );
          widget.onDocumentChanged?.call();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
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
    final isDesktop = size.width >= 860;

    String? statusSubtitle;
    final days = _doc.daysUntilExpiry;
    if (_doc.isPermanent) {
      statusSubtitle = 'Безстроковий документ';
    } else if (days != null) {
      if (days > 0) {
        statusSubtitle = 'Спливає через $days ${_pluralDays(days)}';
      } else if (days == 0) {
        statusSubtitle = 'Спливає сьогодні!';
      } else {
        statusSubtitle = 'Прострочено на ${days.abs()} ${_pluralDays(days.abs())}';
      }
    }

    Widget leftInfoCard = Container(
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
            'Інформація',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          _buildInfoRow('Категорія', _doc.categoryName, isDark),
          _buildInfoRow('Номер / серія', _doc.number ?? 'Не вказано', isDark),
          _buildInfoRow('Орган видачі', _doc.issuer ?? 'Не вказано', isDark),
          _buildInfoRow('Дата видачі', _doc.formattedIssueDate, isDark),
          _buildInfoRow('Дійсний до', _doc.formattedExpiryDate, isDark),
          _buildInfoRow('Нагадування', 'За ${_doc.reminderDays} днів', isDark),
          _buildInfoRow('Нотатки', _doc.notes ?? '—', isDark),
        ],
      ),
    );

    Widget rightFilesCard = Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Електронні копії',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              Text(
                '${_doc.attachments.length} файли',
                style: const TextStyle(fontSize: 13, color: AppColors.textMutedLight),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          if (_doc.attachments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('Прикріплені копії відсутні', style: TextStyle(color: AppColors.textMutedLight)),
              ),
            )
          else ...[
            ..._doc.attachments.map((att) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        att.fileType == 'PDF'
                            ? Icons.picture_as_pdf_outlined
                            : Icons.image_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              att.fileName,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              att.formattedSize,
                              style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.download_outlined, size: 20),
                        tooltip: 'Завантажити',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Завантаження ${att.fileName}...')),
                          );
                        },
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.description_outlined, size: 44, color: AppColors.textMutedLight),
                    const SizedBox(height: 10),
                    Text(
                      'Попередній перегляд ${_doc.attachments.first.fileName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Text(
              _doc.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(width: 12),
            StatusBadge(status: _doc.status, customLabel: statusSubtitle),
          ],
        ),
        actions: [
          CustomButton(
            text: 'Редагувати',
            variant: ButtonVariant.secondary,
            icon: Icons.edit_outlined,
            height: 38,
            onPressed: _handleEdit,
          ),
          const SizedBox(width: 10),
          CustomButton(
            text: 'Видалити',
            variant: ButtonVariant.danger,
            icon: Icons.delete_outline,
            height: 38,
            onPressed: _handleDelete,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: leftInfoCard),
                      const SizedBox(width: 24),
                      Expanded(flex: 5, child: rightFilesCard),
                    ],
                  )
                : Column(
                    children: [
                      leftInfoCard,
                      const SizedBox(height: 20),
                      rightFilesCard,
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  String _pluralDays(int days) {
    if (days % 10 == 1 && days % 100 != 11) return 'день';
    if (days % 10 >= 2 && days % 10 <= 4 && (days % 100 < 10 || days % 100 >= 20)) {
      return 'дні';
    }
    return 'днів';
  }
}
