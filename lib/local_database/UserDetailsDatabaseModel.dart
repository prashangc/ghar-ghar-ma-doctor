const String tableNameUserDetails =
    'UserDetails'; // name of the table in the database

class UserDetailsColumns {
  static final List<String> values = [
    /// Add all fields
    id, userID, fullName, phoneNumber, address, addressType,
  ];

  static const String id = '_id';
  static const String fullName = 'name';
  static const String userID = 'userID';
  static const String phoneNumber = 'phoneNumber';
  static const String address = 'address';
  static const String addressType = 'addressType';
  static const String isAddressDefault = 'isAddressDefault';
} // name of the columns in the table in the database

class UserDetailsDatabaseModel {
  final int? id;
  final int? userID;
  final String? fullName;
  final String? phoneNumber;
  final String address;
  final String? addressType;
  final String? isAddressDefault;

  const UserDetailsDatabaseModel({
    this.id,
    this.userID,
    this.fullName,
    this.phoneNumber,
    required this.address,
    this.addressType,
    this.isAddressDefault,
  });

  UserDetailsDatabaseModel copy({
    final int? id,
    final int? userID,
    final String? fullName,
    final String? phoneNumber,
    final String? address,
    final String? addressType,
    final String? isAddressDefault,
  }) =>
      UserDetailsDatabaseModel(
        id: id ?? this.id,
        userID: userID ?? this.userID,
        fullName: fullName ?? this.fullName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        addressType: addressType ?? this.addressType,
        isAddressDefault: isAddressDefault ?? this.isAddressDefault,
      );

  static UserDetailsDatabaseModel fromJson(Map<String, Object?> json) =>
      UserDetailsDatabaseModel(
        id: json[UserDetailsColumns.id] as int?,
        userID: json[UserDetailsColumns.userID] as int?,
        fullName: json[UserDetailsColumns.fullName] as String,
        phoneNumber: json[UserDetailsColumns.phoneNumber] as String,
        address: json[UserDetailsColumns.address] as String,
        addressType: json[UserDetailsColumns.addressType] as String,
        isAddressDefault: json[UserDetailsColumns.isAddressDefault] as String,
      );
  Map<String, Object?> toJson() => {
        UserDetailsColumns.id: id,
        UserDetailsColumns.userID: userID,
        UserDetailsColumns.fullName: fullName,
        UserDetailsColumns.phoneNumber: phoneNumber,
        UserDetailsColumns.address: address,
        UserDetailsColumns.addressType: addressType,
        UserDetailsColumns.isAddressDefault: isAddressDefault,
      };
}
