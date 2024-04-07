const String waterTableName = 'WaterTable'; // name of the table in the database

class MyWaterDatabaseColumns {
  static final List<String> values = [
    id,
    userID,
    water,
    status,
  ];

  static const String id = '_id';
  static const String userID = 'userID';
  static const String water = 'water';
  static const String status = 'status';
}

class MyWaterDatabaseModel {
  final int? id;
  final String? userID;
  final String? water;
  final String? status;

  const MyWaterDatabaseModel({
    this.id,
    this.userID,
    this.water,
    this.status,
  });

  MyWaterDatabaseModel copy({
    final int? id,
    final String? userID,
    final String? water,
    final String? status,
  }) =>
      MyWaterDatabaseModel(
        id: id ?? this.id,
        userID: userID ?? this.userID,
        water: water ?? water,
        status: status ?? status,
      );

  static MyWaterDatabaseModel fromJson(Map<String, Object?> json) =>
      MyWaterDatabaseModel(
        id: json[MyWaterDatabaseColumns.id] as int?,
        userID: json[MyWaterDatabaseColumns.userID] as String?,
        water: json[MyWaterDatabaseColumns.water] as String?,
        status: json[MyWaterDatabaseColumns.status] as String?,
      );
  Map<String, Object?> toJson() => {
        MyWaterDatabaseColumns.id: id,
        MyWaterDatabaseColumns.userID: userID,
        MyWaterDatabaseColumns.water: water,
        MyWaterDatabaseColumns.status: status,
      };
}
