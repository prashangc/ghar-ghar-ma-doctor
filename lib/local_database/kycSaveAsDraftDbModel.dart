const String tableNameKycDraft = 'KycDraft';

class KycSaveAsDraftColumns {
  static final List<String> values = [
    id,
    userID,
    firstName,
    middleName,
    lastName,
    phone,
    email,
    dob,
    fatherName,
    motherName,
    grandFatherName,
    spouseName,
    gender,
  ];

  static const String id = '_id';
  static const String userID = 'userID';
  static const String firstName = 'firstName';
  static const String middleName = 'middleName';
  static const String lastName = 'lastName';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String dob = 'dob';
  static const String fatherName = 'fatherName';
  static const String motherName = 'motherName';
  static const String grandFatherName = 'grandFatherName';
  static const String spouseName = 'spouseName';
  static const String gender = 'gender';
}

class KycSaveAsDraftDatabaseModel {
  final int? id;
  final int? userID;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? dob;
  final String? fatherName;
  final String? motherName;
  final String? grandFatherName;
  final String? spouseName;
  final String? gender;

  const KycSaveAsDraftDatabaseModel({
    this.id,
    this.userID,
    this.firstName,
    this.middleName,
    this.lastName,
    this.phone,
    this.email,
    this.dob,
    this.fatherName,
    this.motherName,
    this.grandFatherName,
    this.spouseName,
    this.gender,
  });

  KycSaveAsDraftDatabaseModel copy({
    final int? id,
    final int? userID,
    final String? firstName,
    final String? middleName,
    final String? lastName,
    final String? phone,
    final String? email,
    final String? dob,
    final String? fatherName,
    final String? motherName,
    final String? grandFatherName,
    final String? spouseName,
    final String? gender,
  }) =>
      KycSaveAsDraftDatabaseModel(
        id: id ?? this.id,
        userID: userID ?? this.userID,
        firstName: firstName ?? this.firstName,
        middleName: middleName ?? this.middleName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        dob: dob ?? this.dob,
        fatherName: fatherName ?? this.fatherName,
        motherName: motherName ?? this.motherName,
        grandFatherName: grandFatherName ?? this.grandFatherName,
        spouseName: spouseName ?? this.spouseName,
        gender: gender ?? this.gender,
      );

  static KycSaveAsDraftDatabaseModel fromJson(Map<String, Object?> json) =>
      KycSaveAsDraftDatabaseModel(
        id: json[KycSaveAsDraftColumns.id] as int?,
        userID: json[KycSaveAsDraftColumns.userID] as int?,
        firstName: json[KycSaveAsDraftColumns.firstName] as String,
        middleName: json[KycSaveAsDraftColumns.middleName] as String,
        lastName: json[KycSaveAsDraftColumns.lastName] as String,
        phone: json[KycSaveAsDraftColumns.phone] as String,
        email: json[KycSaveAsDraftColumns.email] as String,
        dob: json[KycSaveAsDraftColumns.dob] as String,
        fatherName: json[KycSaveAsDraftColumns.fatherName] as String,
        motherName: json[KycSaveAsDraftColumns.motherName] as String,
        grandFatherName: json[KycSaveAsDraftColumns.grandFatherName] as String,
        spouseName: json[KycSaveAsDraftColumns.spouseName] as String,
        gender: json[KycSaveAsDraftColumns.gender] as String,
      );
  Map<String, Object?> toJson() => {
        KycSaveAsDraftColumns.id: id,
        KycSaveAsDraftColumns.userID: userID,
        KycSaveAsDraftColumns.firstName: firstName,
        KycSaveAsDraftColumns.middleName: middleName,
        KycSaveAsDraftColumns.lastName: lastName,
        KycSaveAsDraftColumns.phone: phone,
        KycSaveAsDraftColumns.email: email,
        KycSaveAsDraftColumns.dob: dob,
        KycSaveAsDraftColumns.fatherName: fatherName,
        KycSaveAsDraftColumns.motherName: motherName,
        KycSaveAsDraftColumns.grandFatherName: grandFatherName,
        KycSaveAsDraftColumns.spouseName: spouseName,
        KycSaveAsDraftColumns.gender: gender,
      };
}
