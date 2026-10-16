import '../core/widgets/status_badge.dart';

/// Модель прикріпленого файлу (електронної копії).
class AttachmentModel {
  final String attachmentId;
  final String fileName;
  final String fileType; // 'PDF', 'JPG', 'PNG'
  final int sizeBytes;
  final String storagePath;
  final DateTime uploadedAt;

  const AttachmentModel({
    required this.attachmentId,
    required this.fileName,
    required this.fileType,
    required this.sizeBytes,
    required this.storagePath,
    required this.uploadedAt,
  });

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} КБ';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} МБ';
  }
}

/// Модель документа (Document).
class DocumentModel {
  final String documentId;
  final String ownerId;
  final String categoryId;
  final String categoryName;
  final String title;
  final String? number;
  final String? issuer;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final int reminderDays;
  final String? notes;
  final List<AttachmentModel> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DocumentModel({
    required this.documentId,
    required this.ownerId,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    this.number,
    this.issuer,
    this.issueDate,
    this.expiryDate,
    this.reminderDays = 30,
    this.notes,
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPermanent => expiryDate == null;

  /// Автоматичне обчислення статусу згідно з FR4 специфікації:
  /// - немає дати закінчення -> Безстроковий
  /// - залишилось більше reminderDays -> Дійсний
  /// - залишилось від 0 до reminderDays -> Спливає скоро
  /// - дата минула -> Прострочений
  DocumentStatus get status {
    if (expiryDate == null) {
      return DocumentStatus.permanent;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate!.year, expiryDate!.month, expiryDate!.day);

    final diff = expiry.difference(today).inDays;

    if (diff < 0) {
      return DocumentStatus.expired;
    } else if (diff <= reminderDays) {
      return DocumentStatus.expiring;
    } else {
      return DocumentStatus.active;
    }
  }

  /// Кількість днів до закінчення або після закінчення
  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate!.year, expiryDate!.month, expiryDate!.day);
    return expiry.difference(today).inDays;
  }

  String get formattedExpiryDate {
    if (expiryDate == null) return 'Безстроковий';
    final d = expiryDate!.day.toString().padLeft(2, '0');
    final m = expiryDate!.month.toString().padLeft(2, '0');
    final y = expiryDate!.year.toString();
    return '$d.$m.$y';
  }

  String get formattedIssueDate {
    if (issueDate == null) return '-';
    final d = issueDate!.day.toString().padLeft(2, '0');
    final m = issueDate!.month.toString().padLeft(2, '0');
    final y = issueDate!.year.toString();
    return '$d.$m.$y';
  }

  DocumentModel copyWith({
    String? categoryId,
    String? categoryName,
    String? title,
    String? number,
    String? issuer,
    DateTime? issueDate,
    DateTime? expiryDate,
    int? reminderDays,
    String? notes,
    List<AttachmentModel>? attachments,
    DateTime? updatedAt,
  }) {
    return DocumentModel(
      documentId: documentId,
      ownerId: ownerId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      title: title ?? this.title,
      number: number ?? this.number,
      issuer: issuer ?? this.issuer,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      reminderDays: reminderDays ?? this.reminderDays,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
