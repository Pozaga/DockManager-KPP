# DocKeeper — Менеджер особистих документів

**Кросплатформний застосунок на базі Flutter (Dart) для каталогізації та контролю строків дії особистих документів.**

- **Дисципліна:** «Кросплатформне програмування»
- **Лабораторна робота №3:** Створення базової структури застосунку та основних екранів відповідно до розробленого дизайну
- **Варіант 18:** «Менеджер особистих документів. Каталог документів із категоріями, строками дії та електронними копіями»
- **Виконавець:** студент групи ПЗ-32 Новосельський Анатолій
- **Керівник:** ст. викл. каф. ПЗ Угриновський Б. В.
- **Прийняв:** асист. каф. ПЗ Паламарчук Д. Ю.

---

## 📌 Реалізовані екрани (відповідно до Лабораторної роботи №2)

1. **Реєстрація та авторизація (FR1, FR2, FR3):**
   - [lib/screens/auth/login_screen.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/auth/login_screen.dart) — екран входу з десктопним двопанельним макетом, брендовою панеллю та переходом на головний екран.
   - [lib/screens/auth/register_screen.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/auth/register_screen.dart) — екран реєстрації з полями введення імені, пошти, пароля, підтвердження та перевіркою збігу.
   - [lib/screens/auth/forgot_password_dialog.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/auth/forgot_password_dialog.dart) — модальний діалог відновлення пароля через електронну пошту.

2. **Головний екран та зведення (FR4):**
   - [lib/screens/home/home_screen.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/home/home_screen.dart) — інформаційні картки лічильників («Усього», «Спливають скоро», «Прострочені»), живий пошук, фільтрація за категоріями та статусами, таблиця документів із кольоровими бейджами, кількістю файлів і контекстним меню дій.

3. **Керування профілем користувача (FR10):**
   - [lib/screens/profile/profile_screen.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/profile/profile_screen.dart) — перегляд і редагування імені, відображення фото/аватара, системної пошти, перемикач теми («Світла», «Темна», «Системна») та вихід із сесії.
   - [lib/screens/profile/change_password_screen.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/profile/change_password_screen.dart) — екран зміни пароля з полями для поточного та нового паролів.

4. **Додаткові реалізовані екрани з дизайну:**
   - [lib/screens/documents/document_detail_screen.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/documents/document_detail_screen.dart) — детальний перегляд документа з атрибутами, статусом дії та списком прикріплених файлів (FR6, FR9).
   - [lib/screens/documents/document_form_screen.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/documents/document_form_screen.dart) — покрокова форма створення/редагування документа (FR5, FR9).
   - [lib/screens/documents/delete_confirmation_dialog.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/documents/delete_confirmation_dialog.dart) — діалог підтвердження безповоротного видалення документа (FR7).
   - [lib/screens/categories/categories_screen.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/categories/categories_screen.dart) — список категорій із лічильниками, редагуванням, захистом від видалення непустих категорій та формою створення з палітрою (FR8).
   - [lib/screens/main_layout.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/screens/main_layout.dart) — адаптивний каркас: бічна розгорнута панель (`Extended Navigation Rail`) для широких вікон (десктоп) та нижня панель навігації для мобільних пристроїв (NFR7).

5. **Повторно використовувані віджети (`core/widgets`):**
   - [lib/core/widgets/custom_text_field.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/core/widgets/custom_text_field.dart) — уніфіковане стилізоване поле вводу з іконками, валідацією та перемикачем видимості пароля.
   - [lib/core/widgets/custom_button.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/core/widgets/custom_button.dart) — стилізовані кнопки (primary, secondary, danger, text) з підтримкою іконок та стану завантаження.
   - [lib/core/widgets/stat_card.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/core/widgets/stat_card.dart) — інтерактивна картка підсумкової статистики з кольоровим акцентом та фільтрацією при натисканні.
   - [lib/core/widgets/status_badge.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/core/widgets/status_badge.dart) — бейдж статусу документа («Дійсний», «Спливає скоро», «Прострочений», «Безстроковий»).
   - [lib/core/widgets/category_badge.dart](file:///d:/PZ/PZ3/Lab3_KPP/lib/core/widgets/category_badge.dart) — індикатор категорії з кольоровою позначкою.

6. **Інтерактивний веб-перегляд (Standalone Preview):**
   - [preview.html](file:///d:/PZ/PZ3/Lab3_KPP/preview.html) — повноцінний інтерактивний веб-інтерфейс, відкривається у будь-якому браузері (Chrome, Edge) подвійним кліком без встановлення сторонніх залежностей.

---

## 📂 Структура проєкту

```
d:/PZ/PZ3/Lab3_KPP/
├── pubspec.yaml                       # Конфігурація Flutter-проєкту та залежності
├── analysis_options.yaml              # Правила статичного лінтування коду Dart
├── preview.html                       # Інтерактивна веб-модель інтерфейсу (Figma-to-Web)
├── README.md                          # Опис та інструкція користувача
├── Звіт_ЛР3_Новосельський.md          # Повний звіт до лабораторної роботи №3
│
└── lib/
    ├── main.dart                      # Точка входу, маршрутизація та перемикання тем
    ├── core/
    │   ├── constants/
    │   │   ├── app_colors.dart        # Колірна палітра інтерфейсу та статусів
    │   │   └── app_typography.dart    # Типографічні константи та стилі тексту
    │   ├── theme/
    │   │   └── app_theme.dart         # Світла й темна теми (Material Design 3)
    │   └── widgets/                   # Пакет повторно використовуваних віджетів
    │       ├── custom_text_field.dart # Стилізоване текстове поле вводу
    │       ├── custom_button.dart     # Кнопка з варіантами стилів
    │       ├── stat_card.dart         # Картка лічильника з фільтрацією
    │       ├── status_badge.dart      # Бейдж статусу з іконкою
    │       └── category_badge.dart    # Індикатор категорії
    ├── models/
    │   ├── user_model.dart            # Сутність користувача
    │   ├── category_model.dart        # Сутність категорії
    │   └── document_model.dart        # Сутність документа та прикріплених файлів
    ├── data/
    │   └── mock_data.dart             # Тестові hardcoded-дані відповідно до макетів Лаб 2
    └── screens/
        ├── main_layout.dart           # Адаптивна навігаційна панель
        ├── auth/
        │   ├── login_screen.dart      # Екран авторизації (FR2)
        │   ├── register_screen.dart   # Екран реєстрації (FR1)
        │   └── forgot_password_dialog.dart # Діалог відновлення пароля (FR3)
        ├── home/
        │   └── home_screen.dart       # Головний екран: зведення, таблиця, фільтри (FR4)
        ├── profile/
        │   ├── profile_screen.dart    # Керування профілем користувача (FR10)
        │   └── change_password_screen.dart # Екран зміни пароля (FR10)
        ├── documents/
        │   ├── document_detail_screen.dart # Перегляд деталей і файлів (FR6, FR9)
        │   ├── document_form_screen.dart   # Створення/редагування (FR5, FR9)
        │   └── delete_confirmation_dialog.dart # Діалог видалення (FR7)
        └── categories/
            └── categories_screen.dart # Керування категоріями (FR8)
```

---

## 🚀 Запуск проєкту у Flutter

1. Переконайтеся, що встановлено Flutter SDK:
   ```bash
   flutter doctor
   ```
2. Отримайте залежності:
   ```bash
   flutter pub get
   ```
3. Запустіть застосунок на цільовій платформі (Windows або Chrome):
   ```bash
   flutter run -d chrome
   # або
   flutter run -d windows
   ```
