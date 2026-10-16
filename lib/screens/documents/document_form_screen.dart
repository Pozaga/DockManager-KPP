import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/mock_data.dart';
import '../../models/document_model.dart';

/// Екран створення та редагування документа (FR5, FR9, Рис. 5 макетів).
class DocumentFormScreen extends StatefulWidget {
  final DocumentModel? document;

  const DocumentFormScreen({super.key, this.document});

  @override
  State<DocumentFormScreen> createState() => _DocumentFormScreenState();
}

class _DocumentFormScreenState extends State<DocumentFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _numberController;
  late final TextEditingController _issuerController;
  late final TextEditingController _issueDateController;
  late final TextEditingController _expiryDateController;
  late final TextEditingController _notesController;

  late String _selectedCategoryId;
  late bool _isPermanent;
  late int _reminderDays;
  late List<AttachmentModel> _attachments;

  @override
  void initState() {
    super.initState();
    final doc = widget.document;
    _titleController = TextEditingController(text: doc?.title ?? '');
    _numberController = TextEditingController(text: doc?.number ?? '');
    _issuerController = TextEditingController(text: doc?.issuer ?? '');
    _issueDateController =
        TextEditingController(text: doc?.formattedIssueDate ?? '12.03.2024');
    _expiryDateController = TextEditingController(
      text: doc != null ? (doc.isPermanent ? '' : doc.formattedExpiryDate) : '12.03.2029',
    );
    _notesController = TextEditingController(text: doc?.notes ?? '');

    _selectedCategoryId =
        doc?.categoryId ?? MockData.categories.first.categoryId;
    _isPermanent = doc?.isPermanent ?? false;
    _reminderDays = doc?.reminderDays ?? 30;
    _attachments = List.from(doc?.attachments ?? [
      AttachmentModel(
        attachmentId: 'att_sample',
        fileName: 'passport_scan.pdf',
        fileType: 'PDF',
        sizeBytes: 1258291,
        storagePath: 'temp/passport_scan.pdf',
        uploadedAt: DateTime(2026, 9, 10),
      ),
    ]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _numberController.dispose();
    _issuerController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вкажіть назву документа!')),
      );
      return;
    }

    final cat = MockData.categories.firstWhere(
      (c) => c.categoryId == _selectedCategoryId,
      orElse: () => MockData.categories.first,
    );

    final updatedDoc = DocumentModel(
      documentId: widget.document?.documentId ?? 'doc_${DateTime.now().millisecondsSinceEpoch}',
      ownerId: 'usr_001',
      categoryId: cat.categoryId,
      categoryName: cat.name,
      title: _titleController.text.trim(),
      number: _numberController.text.trim(),
      issuer: _issuerController.text.trim(),
      issueDate: DateTime.now().subtract(const Duration(days: 365)),
      expiryDate: _isPermanent ? null : DateTime.now().add(const Duration(days: 365)),
      reminderDays: _reminderDays,
      notes: _notesController.text.trim(),
      attachments: _attachments,
      createdAt: widget.document?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Документ збережено'),
        backgroundColor: AppColors.statusActive,
      ),
    );

    Navigator.of(context).pop(updatedDoc);
  }

  Widget _buildSectionHeader(String number, String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEdit = widget.document != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isEdit ? 'Редагувати документ' : 'Додати документ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          CustomButton(
            text: 'Скасувати',
            variant: ButtonVariant.secondary,
            height: 38,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 10),
          CustomButton(
            text: 'Зберегти',
            variant: ButtonVariant.primary,
            height: 38,
            onPressed: _handleSave,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 820),
            padding: const EdgeInsets.all(32),
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
                // 1. Основне
                _buildSectionHeader('1', 'Основне', isDark),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: CustomTextField(
                        label: 'Назва *',
                        controller: _titleController,
                        hintText: 'наприклад, Паспорт громадянина України',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Категорія *',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategoryId,
                            items: MockData.categories.map((c) {
                              return DropdownMenuItem(
                                value: c.categoryId,
                                child: Text(c.name),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedCategoryId = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Серія / номер',
                        controller: _numberController,
                        hintText: 'CH 123456',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Орган видачі',
                        controller: _issuerController,
                        hintText: 'ДМС України',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 2. Строки дії
                _buildSectionHeader('2', 'Строки дії', isDark),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Дата видачі',
                        controller: _issueDateController,
                        hintText: 'ДД.ММ.РРРР',
                        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Дійсний до',
                        controller: _expiryDateController,
                        hintText: 'ДД.ММ.РРРР',
                        readOnly: _isPermanent,
                        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: _isPermanent,
                      onChanged: (val) {
                        setState(() {
                          _isPermanent = val ?? false;
                        });
                      },
                    ),
                    const Text('Безстроковий', style: TextStyle(fontSize: 14)),
                    const Spacer(),
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<int>(
                        initialValue: _reminderDays,
                        decoration: const InputDecoration(labelText: 'Нагадати за (днів)'),
                        items: const [
                          DropdownMenuItem(value: 7, child: Text('За 7 днів')),
                          DropdownMenuItem(value: 14, child: Text('За 14 днів')),
                          DropdownMenuItem(value: 30, child: Text('За 30 днів')),
                          DropdownMenuItem(value: 60, child: Text('За 60 днів')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _reminderDays = val;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 3. Нотатки та файли
                _buildSectionHeader('3', 'Нотатки та файли', isDark),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Нотатки',
                  controller: _notesController,
                  hintText: 'Додаткові примітки, місце зберігання оригіналу...',
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  'Електронні копії',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _attachments.add(
                        AttachmentModel(
                          attachmentId: 'att_${DateTime.now().millisecondsSinceEpoch}',
                          fileName: 'scan_doc_${_attachments.length + 1}.pdf',
                          fileType: 'PDF',
                          sizeBytes: 940000,
                          storagePath: 'temp/scan.pdf',
                          uploadedAt: DateTime.now(),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: const Text('Додати файл (PDF, JPG, PNG)'),
                ),
                const SizedBox(height: 12),
                ..._attachments.map((att) => Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.picture_as_pdf, size: 20, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(att.fileName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                Text(att.formattedSize, style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _attachments.remove(att);
                              });
                            },
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
