/// Модель користувача застосунку (User).
class UserModel {
  final String userId;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String theme; // 'light', 'dark', 'system'
  final DateTime createdAt;

  const UserModel({
    required this.userId,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.theme = 'system',
    required this.createdAt,
  });

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? theme,
  }) {
    return UserModel(
      userId: userId,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      theme: theme ?? this.theme,
      createdAt: createdAt,
    );
  }
}
