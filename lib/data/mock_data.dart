import '../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../models/document_model.dart';
import '../models/user_model.dart';

/// Статичні тестові дані для застосунку DocKeeper (згідно з макетами Лаб 2).
class MockData {
  MockData._();

  /// Поточний авторизований користувач
  static UserModel currentUser = UserModel(
    userId: 'usr_001',
    email: 'olena@example.com',
    displayName: 'Олена Ковальчук',
    theme: 'light',
    createdAt: DateTime(2026, 9, 1),
  );

  /// Категорії документів
  static List<CategoryModel> categories = [
    CategoryModel(
      categoryId: 'cat_personal',
      ownerId: 'usr_001',
      name: 'Особисті',
      color: AppColors.categoryPersonal,
      documentCount: 1,
      createdAt: DateTime(2026, 9, 1),
    ),
    CategoryModel(
      categoryId: 'cat_transport',
      ownerId: 'usr_001',
      name: 'Транспорт',
      color: AppColors.categoryTransport,
      documentCount: 1,
      createdAt: DateTime(2026, 9, 1),
    ),
    CategoryModel(
      categoryId: 'cat_finance',
      ownerId: 'usr_001',
      name: 'Фінанси',
      color: AppColors.categoryFinance,
      documentCount: 1,
      createdAt: DateTime(2026, 9, 1),
    ),
    CategoryModel(
      categoryId: 'cat_education',
      ownerId: 'usr_001',
      name: 'Освіта',
      color: AppColors.categoryEducation,
      documentCount: 1,
      createdAt: DateTime(2026, 9, 1),
    ),
    CategoryModel(
      categoryId: 'cat_housing',
      ownerId: 'usr_001',
      name: 'Житло',
      color: AppColors.categoryHousing,
      documentCount: 1,
      createdAt: DateTime(2026, 9, 1),
    ),
  ];

  /// Список документів (повністю відповідає макетам з рисунків 4, 5, 6 Лаб 2)
  static List<DocumentModel> documents = [
    DocumentModel(
      documentId: 'doc_1',
      ownerId: 'usr_001',
      categoryId: 'cat_personal',
      categoryName: 'Особисті',
      title: 'Паспорт',
      number: 'CH 123456',
      issuer: 'ДМС України',
      issueDate: DateTime(2017, 3, 12),
      expiryDate: DateTime(2027, 3, 12),
      reminderDays: 30,
      notes: 'Зберігається у сейфі вдома.',
      attachments: [
        AttachmentModel(
          attachmentId: 'att_1',
          fileName: 'passport_scan.pdf',
          fileType: 'PDF',
          sizeBytes: 1258291, // ~1.2 MB
          storagePath: 'documents/doc_1/passport_scan.pdf',
          uploadedAt: DateTime(2026, 9, 10),
        ),
        AttachmentModel(
          attachmentId: 'att_2',
          fileName: 'id_card_back.jpg',
          fileType: 'JPG',
          sizeBytes: 854000,
          storagePath: 'documents/doc_1/id_card_back.jpg',
          uploadedAt: DateTime(2026, 9, 10),
        ),
      ],
      createdAt: DateTime(2026, 9, 10),
      updatedAt: DateTime(2026, 9, 10),
    ),
    DocumentModel(
      documentId: 'doc_2',
      ownerId: 'usr_001',
      categoryId: 'cat_transport',
      categoryName: 'Транспорт',
      title: 'Водійське посвідчення',
      number: 'BXT 789456',
      issuer: 'ТСЦ 4641',
      issueDate: DateTime(2021, 11, 8),
      expiryDate: DateTime(2031, 11, 8),
      reminderDays: 30,
      notes: 'Категорія В. Потрібно перевірити статус перед виїздом за кордон.',
      attachments: [
        AttachmentModel(
          attachmentId: 'att_3',
          fileName: 'driver_license.pdf',
          fileType: 'PDF',
          sizeBytes: 1572864, // 1.5 MB
          storagePath: 'documents/doc_2/driver_license.pdf',
          uploadedAt: DateTime(2026, 9, 12),
        ),
      ],
      createdAt: DateTime(2026, 9, 12),
      updatedAt: DateTime(2026, 9, 12),
    ),
    DocumentModel(
      documentId: 'doc_3',
      ownerId: 'usr_001',
      categoryId: 'cat_finance',
      categoryName: 'Фінанси',
      title: 'Страховий поліс',
      number: 'POL-992341',
      issuer: 'НАСК Оранта',
      issueDate: DateTime(2025, 2, 1),
      expiryDate: DateTime(2026, 2, 1), // Минула дата -> Прострочений
      reminderDays: 14,
      notes: 'Обов’язкове страхування автоцивілки. Необхідно терміново поновити!',
      attachments: [
        AttachmentModel(
          attachmentId: 'att_4',
          fileName: 'insurance_policy.pdf',
          fileType: 'PDF',
          sizeBytes: 2100000,
          storagePath: 'documents/doc_3/insurance_policy.pdf',
          uploadedAt: DateTime(2026, 9, 14),
        ),
        AttachmentModel(
          attachmentId: 'att_5',
          fileName: 'euro_protocol.pdf',
          fileType: 'PDF',
          sizeBytes: 524288,
          storagePath: 'documents/doc_3/euro_protocol.pdf',
          uploadedAt: DateTime(2026, 9, 14),
        ),
        AttachmentModel(
          attachmentId: 'att_6',
          fileName: 'receipt.png',
          fileType: 'PNG',
          sizeBytes: 312000,
          storagePath: 'documents/doc_3/receipt.png',
          uploadedAt: DateTime(2026, 9, 14),
        ),
      ],
      createdAt: DateTime(2026, 9, 14),
      updatedAt: DateTime(2026, 9, 14),
    ),
    DocumentModel(
      documentId: 'doc_4',
      ownerId: 'usr_001',
      categoryId: 'cat_education',
      categoryName: 'Освіта',
      title: 'Диплом',
      number: 'В22 № 543210',
      issuer: 'НУ "Львівська політехніка"',
      issueDate: DateTime(2024, 6, 30),
      expiryDate: null, // Безстроковий
      reminderDays: 0,
      notes: 'Диплом бакалавра з відзнакою. Додаток зберігається разом із дипломом.',
      attachments: [
        AttachmentModel(
          attachmentId: 'att_7',
          fileName: 'diploma_bachelor.pdf',
          fileType: 'PDF',
          sizeBytes: 3400000,
          storagePath: 'documents/doc_4/diploma_bachelor.pdf',
          uploadedAt: DateTime(2026, 9, 15),
        ),
      ],
      createdAt: DateTime(2026, 9, 15),
      updatedAt: DateTime(2026, 9, 15),
    ),
    DocumentModel(
      documentId: 'doc_5',
      ownerId: 'usr_001',
      categoryId: 'cat_housing',
      categoryName: 'Житло',
      title: 'Договір оренди',
      number: '№ 2024-114',
      issuer: 'Приватний договір',
      issueDate: DateTime(2024, 10, 30),
      expiryDate: DateTime(2026, 10, 30), // Менше місяця -> Спливає скоро!
      reminderDays: 31,
      notes: 'Оренда квартири, вул. Хрещатик. Контакт орендодавця: +380501234567.',
      attachments: [
        AttachmentModel(
          attachmentId: 'att_8',
          fileName: 'lease_agreement.pdf',
          fileType: 'PDF',
          sizeBytes: 1468006, // 1.4 МБ
          storagePath: 'documents/doc_5/lease_agreement.pdf',
          uploadedAt: DateTime(2026, 9, 16),
        ),
        AttachmentModel(
          attachmentId: 'att_9',
          fileName: 'lease_annex.pdf',
          fileType: 'PDF',
          sizeBytes: 838860, // 0.8 МБ
          storagePath: 'documents/doc_5/lease_annex.pdf',
          uploadedAt: DateTime(2026, 9, 16),
        ),
      ],
      createdAt: DateTime(2026, 9, 16),
      updatedAt: DateTime(2026, 9, 16),
    ),
  ];
}
