const String tableNameLoginAutoSuggestion = 'LoginAutoSuggestion';

class LoginAutoSuggestionColumns {
  static final List<String> values = [
    id,
    userId,
    email,
    phone,
    date,
  ];

  static const String id = '_id';
  static const String userId = 'userId';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String date = 'date';
}

class LoginAutoSuggestionModel {
  final int? id;
  final int? userId;
  final String? email;
  final String? phone;
  final String? date;

  const LoginAutoSuggestionModel({
    this.id,
    this.userId,
    this.email,
    this.phone,
    this.date,
  });

  LoginAutoSuggestionModel copy({
    final int? id,
    final int? userId,
    final String? email,
    final String? phone,
    final String? date,
  }) =>
      LoginAutoSuggestionModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        date: date ?? this.date,
      );

  static LoginAutoSuggestionModel fromJson(Map<String, Object?> json) =>
      LoginAutoSuggestionModel(
        id: json[LoginAutoSuggestionColumns.id] as int?,
        userId: json[LoginAutoSuggestionColumns.userId] as int?,
        email: json[LoginAutoSuggestionColumns.email] as String?,
        phone: json[LoginAutoSuggestionColumns.phone] as String?,
        date: json[LoginAutoSuggestionColumns.date] as String?,
      );
  Map<String, Object?> toJson() => {
        LoginAutoSuggestionColumns.id: id,
        LoginAutoSuggestionColumns.userId: userId,
        LoginAutoSuggestionColumns.email: email,
        LoginAutoSuggestionColumns.phone: phone,
        LoginAutoSuggestionColumns.date: date,
      };
}
