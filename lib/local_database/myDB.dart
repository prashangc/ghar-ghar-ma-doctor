import 'package:flutter/foundation.dart';
import 'package:ghargharmadoctor/local_database/CartDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/GlobalFormSaveAsDraft.dart';
import 'package:ghargharmadoctor/local_database/LoginEmailAutoSuggestionModel.dart';
import 'package:ghargharmadoctor/local_database/UserDetailsDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/WaterCupDBModel.dart';
import 'package:ghargharmadoctor/local_database/kycSaveAsDraftDbModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static final MyDatabase instance = MyDatabase._init();

  static Database? _database;
  MyDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Hari92.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const primaryKeyDataType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intergerDataType = 'INTEGER';
    const stringDataType = 'TEXT';
    const dateDataType = 'DATE';

    await db.execute('''
  CREATE TABLE $tableName (
    ${MyCartDatabaseColumns.id} $primaryKeyDataType,
    ${MyCartDatabaseColumns.userID} $intergerDataType,
    ${MyCartDatabaseColumns.productID} $intergerDataType,
    ${MyCartDatabaseColumns.vendorID} $intergerDataType,
    ${MyCartDatabaseColumns.productName} $stringDataType,
    ${MyCartDatabaseColumns.productPrice} $stringDataType,
    ${MyCartDatabaseColumns.sellingPriceAfterDiscount} $stringDataType,
    ${MyCartDatabaseColumns.totalSellingPriceAfterDiscount} $stringDataType,
    ${MyCartDatabaseColumns.productQuantity} $stringDataType,
    ${MyCartDatabaseColumns.productTotalAmount} $stringDataType,
    ${MyCartDatabaseColumns.discount} $stringDataType,
    ${MyCartDatabaseColumns.productUnit} $stringDataType,
    ${MyCartDatabaseColumns.productImage} $stringDataType,
    ${MyCartDatabaseColumns.stock} $stringDataType

  )''');

    await db.execute('''
  CREATE TABLE $tableNameUserDetails (
    ${UserDetailsColumns.id} $primaryKeyDataType,
    ${UserDetailsColumns.userID} $intergerDataType,
    ${UserDetailsColumns.fullName} $stringDataType,
    ${UserDetailsColumns.phoneNumber} $stringDataType,
    ${UserDetailsColumns.address} $stringDataType,
    ${UserDetailsColumns.addressType} $stringDataType,
    ${UserDetailsColumns.isAddressDefault} $stringDataType

  )''');

    await db.execute('''
  CREATE TABLE $tableNameKycDraft (
    ${KycSaveAsDraftColumns.id} $primaryKeyDataType,
    ${KycSaveAsDraftColumns.userID} $intergerDataType,
    ${KycSaveAsDraftColumns.firstName} $stringDataType,
    ${KycSaveAsDraftColumns.middleName} $stringDataType,
    ${KycSaveAsDraftColumns.lastName} $stringDataType,
    ${KycSaveAsDraftColumns.phone} $stringDataType,
    ${KycSaveAsDraftColumns.email} $stringDataType,
    ${KycSaveAsDraftColumns.dob} $stringDataType,
    ${KycSaveAsDraftColumns.fatherName} $stringDataType,
    ${KycSaveAsDraftColumns.motherName} $stringDataType,
    ${KycSaveAsDraftColumns.grandFatherName} $stringDataType,
    ${KycSaveAsDraftColumns.spouseName} $stringDataType,
    ${KycSaveAsDraftColumns.gender} $stringDataType

  )''');

    await db.execute('''
  CREATE TABLE $tableNameGlobalFormDraft (
    ${GlobalFormDraftColumns.id} $primaryKeyDataType,
    ${GlobalFormDraftColumns.userID} $intergerDataType,
    ${GlobalFormDraftColumns.salutation} $stringDataType,
    ${GlobalFormDraftColumns.firstName} $stringDataType,
    ${GlobalFormDraftColumns.middleName} $stringDataType,
    ${GlobalFormDraftColumns.lastName} $stringDataType,
    ${GlobalFormDraftColumns.phone} $stringDataType,
    ${GlobalFormDraftColumns.email} $stringDataType,
    ${GlobalFormDraftColumns.dobNep} $stringDataType,
    ${GlobalFormDraftColumns.dobEng} $stringDataType,
    ${GlobalFormDraftColumns.gender} $stringDataType,
    ${GlobalFormDraftColumns.nationality} $stringDataType,
    ${GlobalFormDraftColumns.branch} $stringDataType,
    ${GlobalFormDraftColumns.country} $stringDataType,
    ${GlobalFormDraftColumns.houseNoPerm} $stringDataType,
    ${GlobalFormDraftColumns.provinceIDPerm} $stringDataType,
    ${GlobalFormDraftColumns.provinceNamePerm} $stringDataType,
    ${GlobalFormDraftColumns.districtIDPerm} $stringDataType,
    ${GlobalFormDraftColumns.districtNamePerm} $stringDataType,
    ${GlobalFormDraftColumns.vdcIDPerm} $stringDataType,
    ${GlobalFormDraftColumns.vdcNamePerm} $stringDataType,
    ${GlobalFormDraftColumns.wardIDPerm} $stringDataType,
    ${GlobalFormDraftColumns.wardNamePerm} $stringDataType,
    ${GlobalFormDraftColumns.permanentAddress} $stringDataType,
    ${GlobalFormDraftColumns.houseNoTemp} $stringDataType,
    ${GlobalFormDraftColumns.provinceIDTemp} $stringDataType,
    ${GlobalFormDraftColumns.provinceNameTemp} $stringDataType,
    ${GlobalFormDraftColumns.districtIDTemp} $stringDataType,
    ${GlobalFormDraftColumns.districtNameTemp} $stringDataType,
    ${GlobalFormDraftColumns.vdcIDTemp} $stringDataType,
    ${GlobalFormDraftColumns.vdcNameTemp} $stringDataType,
    ${GlobalFormDraftColumns.wardIDTemp} $stringDataType,
    ${GlobalFormDraftColumns.wardNameTemp} $stringDataType,
    ${GlobalFormDraftColumns.temporaryAddress} $stringDataType,
    ${GlobalFormDraftColumns.workStatus} $stringDataType,
    ${GlobalFormDraftColumns.purposeOfAccount} $stringDataType,
    ${GlobalFormDraftColumns.incomeSource} $stringDataType,
    ${GlobalFormDraftColumns.annualIncome} $stringDataType,
    ${GlobalFormDraftColumns.occupation} $stringDataType,
    ${GlobalFormDraftColumns.pan} $stringDataType,
    ${GlobalFormDraftColumns.organizationName} $stringDataType,
    ${GlobalFormDraftColumns.organizationAddress} $stringDataType,
    ${GlobalFormDraftColumns.organizationContact} $stringDataType,
    ${GlobalFormDraftColumns.designation} $stringDataType,
    ${GlobalFormDraftColumns.identificationType} $stringDataType,
    ${GlobalFormDraftColumns.identificationDocNumber} $stringDataType,
    ${GlobalFormDraftColumns.issuedDateEng} $stringDataType,
    ${GlobalFormDraftColumns.issuedDateNep} $stringDataType,
    ${GlobalFormDraftColumns.issuedDistrict} $stringDataType,
    ${GlobalFormDraftColumns.fatherName} $stringDataType,
    ${GlobalFormDraftColumns.motherName} $stringDataType,
    ${GlobalFormDraftColumns.grandFatherName} $stringDataType,
    ${GlobalFormDraftColumns.spouseName} $stringDataType,
    ${GlobalFormDraftColumns.grandMotherName} $stringDataType,
    ${GlobalFormDraftColumns.maritalStatus} $stringDataType,
    ${GlobalFormDraftColumns.education} $stringDataType,
    ${GlobalFormDraftColumns.maxAmount} $stringDataType,
    ${GlobalFormDraftColumns.monthlyAmount} $stringDataType,
    ${GlobalFormDraftColumns.yearlyAmount} $stringDataType,
    ${GlobalFormDraftColumns.noOfMonthlyTransaction} $stringDataType,
    ${GlobalFormDraftColumns.noOfyearlyTransaction} $stringDataType,
    ${GlobalFormDraftColumns.nomineeName} $stringDataType,
    ${GlobalFormDraftColumns.nomineeFatherName} $stringDataType,
    ${GlobalFormDraftColumns.nomineeGrandfatherName} $stringDataType,
    ${GlobalFormDraftColumns.nomineeRelation} $stringDataType,
    ${GlobalFormDraftColumns.nomineeDobEng} $stringDataType,
    ${GlobalFormDraftColumns.nomineeDobNep} $stringDataType,
    ${GlobalFormDraftColumns.nomineeCitizenship} $stringDataType,
    ${GlobalFormDraftColumns.nomineeCitizenshipIssuedPlace} $stringDataType,
    ${GlobalFormDraftColumns.nomineeCitizenshipIssuedDateEng} $stringDataType,
    ${GlobalFormDraftColumns.nomineeCitizenshipIssuedDateNep} $stringDataType,
    ${GlobalFormDraftColumns.nomineePhone} $stringDataType,
    ${GlobalFormDraftColumns.nomineeCurrentAddress} $stringDataType,
    ${GlobalFormDraftColumns.nomineePermanentAddress} $stringDataType,
    ${GlobalFormDraftColumns.beneficiaryName} $stringDataType,
    ${GlobalFormDraftColumns.beneficiaryRelation} $stringDataType,
    ${GlobalFormDraftColumns.beneficiaryPhone} $stringDataType,
    ${GlobalFormDraftColumns.beneficiaryAddress} $stringDataType

  )''');

    await db.execute('''
  CREATE TABLE $tableNameLoginAutoSuggestion (
    ${LoginAutoSuggestionColumns.id} $primaryKeyDataType,
    ${LoginAutoSuggestionColumns.userId} $intergerDataType,
    ${LoginAutoSuggestionColumns.email} $stringDataType,
    ${LoginAutoSuggestionColumns.phone} $stringDataType,
    ${LoginAutoSuggestionColumns.date} $dateDataType

  )''');

    await db.execute('''
  CREATE TABLE $waterTableName (
    ${MyWaterDatabaseColumns.id} $primaryKeyDataType,
    ${MyWaterDatabaseColumns.userID} $stringDataType,
    ${MyWaterDatabaseColumns.water} $stringDataType,
    ${MyWaterDatabaseColumns.status} $stringDataType

  )''');
  }

  Future<MyCartDatabaseModel> create(
      MyCartDatabaseModel cartDatabaseModel) async {
    final db = await instance.database;

    final id = await db.insert(tableName, cartDatabaseModel.toJson());
    return cartDatabaseModel.copy(id: id);
  }

  void addToCartLocalDB(MyCartDatabaseModel cartDatabaseModel) async {
    try {
      final db = await instance.database;
      final result = await db.insert(tableName, cartDatabaseModel.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  void addUserDetailsToLocalDB(
      UserDetailsDatabaseModel userDetailsDatabaseModel) async {
    try {
      final db = await instance.database;
      final result = await db.insert(
          tableNameUserDetails, userDetailsDatabaseModel.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  void addKycDraft(
      KycSaveAsDraftDatabaseModel kycSaveAsDraftDatabaseModel) async {
    try {
      final db = await instance.database;
      final result = await db.insert(
          tableNameKycDraft, kycSaveAsDraftDatabaseModel.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  void addGlobalFormDraft(
      GlobalFormDraftDatabaseModel globalFormDraftDatabaseModel) async {
    try {
      final db = await instance.database;
      final result = await db.insert(
          tableNameGlobalFormDraft, globalFormDraftDatabaseModel.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  // Future<int> updateGlobalFormDraft(
  //     GlobalFormDraftDatabaseModel globalFormDraftDatabaseModel,
  //     key,
  //     value) async {
  //   final db = await instance.database;
  //   return db.update(
  //     tableNameGlobalFormDraft,
  //     globalFormDraftDatabaseModel.toJson(),
  //     where: '$key = $value',
  //     whereArgs: [globalFormDraftDatabaseModel.id],
  //   );
  Future<int> updateGlobalFormDraft(key, value) async {
    final db = await instance.database;
    GlobalFormDraftDatabaseModel globalFormDraftDatabaseModel =
        const GlobalFormDraftDatabaseModel();
    return db.rawUpdate(
        'UPDATE $tableNameGlobalFormDraft SET ($key) = (?) WHERE _id = ?',
        [value, 1]);
    // db.update(
    //   tableNameGlobalFormDraft,
    //   globalFormDraftDatabaseModel.toJson(),
    //   where: '_id = ?',
    //   whereArgs: [value],
    // );
    // Future<int> updateGlobalFormDraft(attribute) async {
    // Map<String, dynamic> row = {
    //     GlobalFormDraftColumns.firstName : 'Mary',
    //   };
    //   final db = await instance.database;
    //   return db.update(
    //     tableNameGlobalFormDraft,
    //     row, //{'firstName': Ram}
    //     where: '$attribute = ?', // ''
    //     whereArgs: [1],
    //   );
  }

  Future<int> updateKycDraft(
      KycSaveAsDraftDatabaseModel kycSaveAsDraftDatabaseModel) async {
    final db = await instance.database;
    return db.update(
      tableNameKycDraft,
      kycSaveAsDraftDatabaseModel.toJson(),
      where: '${KycSaveAsDraftColumns.id} = ?',
      whereArgs: [kycSaveAsDraftDatabaseModel.id],
    );
  }

  Future<List<KycSaveAsDraftDatabaseModel>> fetchKycDraftData(userID) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT * FROM $tableNameKycDraft WHERE ${KycSaveAsDraftColumns.userID} = ?',
        [userID]);
    return result
        .map((json) => KycSaveAsDraftDatabaseModel.fromJson(json))
        .toList();
  }

  Future<List<GlobalFormDraftDatabaseModel>> fetchGlobalFormDraftData(
      userID) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT * FROM $tableNameGlobalFormDraft WHERE ${GlobalFormDraftColumns.userID} = ?',
        [userID]);
    return result
        .map((json) => GlobalFormDraftDatabaseModel.fromJson(json))
        .toList();
  }

  Future<List<MyCartDatabaseModel>> fetchDataFromCart(userID) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE ${MyCartDatabaseColumns.userID} = ?',
        [userID]);
    return result.map((json) => MyCartDatabaseModel.fromJson(json)).toList();
  }

  Future<List<MyCartDatabaseModel>> fetchAddedProductFromCart(
      userID, productID) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE (${MyCartDatabaseColumns.userID}, ${MyCartDatabaseColumns.productID})  = (?,?)',
        [userID, productID]);
    return result.map((json) => MyCartDatabaseModel.fromJson(json)).toList();
  }

  Future<List<UserDetailsDatabaseModel>> fetchDataFromUserDetails(
      userID) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT * FROM $tableNameUserDetails WHERE ${UserDetailsColumns.userID} = ?',
        [userID]);
    return result
        .map((json) => UserDetailsDatabaseModel.fromJson(json))
        .toList();
  }

  Future<int> update(MyCartDatabaseModel cartDatabaseModel) async {
    final db = await instance.database;
    return db.update(
      tableName,
      cartDatabaseModel.toJson(),
      where: '${MyCartDatabaseColumns.id} = ?',
      whereArgs: [cartDatabaseModel.id],
    );
  }

  void updateQuantityInLocalDB(
      quantity, newTOtal, totalSellingPriceAfterDiscount, stock, id) async {
    try {
      final db = await instance.database;
      final result = await db.rawUpdate(
          'UPDATE $tableName SET (${MyCartDatabaseColumns.productQuantity},  ${MyCartDatabaseColumns.productTotalAmount}, ${MyCartDatabaseColumns.totalSellingPriceAfterDiscount}, ${MyCartDatabaseColumns.stock}) = (?,?,?,?) WHERE _id = ?',
          [quantity, newTOtal, totalSellingPriceAfterDiscount, stock, id]);
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  void updateAddressTable(fullName, address, phone, addressType, id) async {
    try {
      final db = await instance.database;
      final result = await db.rawUpdate(
          'UPDATE $tableNameUserDetails SET (${UserDetailsColumns.fullName}, ${UserDetailsColumns.address}, ${UserDetailsColumns.phoneNumber}, ${UserDetailsColumns.addressType} ) = (?,?,?, ?) WHERE _id = ?',
          [fullName, address, phone, addressType, id]);
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  Future<int> delete(List<String> id) async {
    final db = await instance.database;
    String listOfQuestionMark = '?';
    for (int i = 1; i < id.length; i++) {
      listOfQuestionMark = '$listOfQuestionMark , ?';
    }
    return await db.delete(
      tableName,
      where: '${MyCartDatabaseColumns.id} IN ($listOfQuestionMark)',
      whereArgs: id,
    );
  }

  Future<int> deleteAddress(id) async {
    final db = await instance.database;

    return await db.delete(
      tableNameUserDetails,
      where: '${UserDetailsColumns.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllFromCart() async {
    final db = await instance.database;
    return await db.rawDelete('DELETE FROM $tableName');
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    db.close();
  }

  void addLoginAutoSuggestionToDb(
      LoginAutoSuggestionModel loginAutoSuggestionModel) async {
    try {
      final db = await instance.database;
      final result = await db.insert(
          tableNameLoginAutoSuggestion, loginAutoSuggestionModel.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  Future<List<LoginAutoSuggestionModel>> fetchEmailsFromDb() async {
    final db = await instance.database;
    final result = await db.query(
      tableNameLoginAutoSuggestion,
    );
    return result
        .map((json) => LoginAutoSuggestionModel.fromJson(json))
        .toList();
  }

  fetchOnlyEmailOrPhoneFromSearchInput(input) async {
    final db = await instance.database;
    List<Map<String, dynamic>> results = [];

    if (int.tryParse(input) != null) {
      results = await db.query(
        tableNameLoginAutoSuggestion,
        where: 'phone LIKE ?',
        whereArgs: ['%$input%'],
        orderBy: 'date DESC',
      );
    } else {
      results = await db.query(
        tableNameLoginAutoSuggestion,
        where: 'email LIKE ?',
        whereArgs: ['%$input%'],
        orderBy: 'date DESC',
      );
    }
    return results
        .map((json) => LoginAutoSuggestionModel.fromJson(json))
        .toList();
  }

  checkIfUserIdExits(userID) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT * FROM $tableNameLoginAutoSuggestion WHERE (${LoginAutoSuggestionColumns.userId} = ?)',
        [userID]);
    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  checkIfEmailOrPhoneIsNullOrNOt(userId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $tableNameLoginAutoSuggestion WHERE ${LoginAutoSuggestionColumns.userId} = ? AND (${LoginAutoSuggestionColumns.email} IS NULL OR ${LoginAutoSuggestionColumns.phone} IS NULL)',
        [userId]);
    var test =
        result.map((json) => LoginAutoSuggestionModel.fromJson(json)).toList();
    String key = '';
    if (test[0].phone == null) {
      key = 'phone';
    } else if (test[0].email == null) {
      key = 'email';
    }
    return key;
  }

  findOldestDateRow() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT * FROM $tableNameLoginAutoSuggestion ORDER BY ${LoginAutoSuggestionColumns.date} ASC LIMIT 1');
    return result.first['_id'] as int?;
  }

  Future<void> updatePhoneOrEmail(userID, columnName, value) async {
    final db = await instance.database;
    await db.update(
      tableNameLoginAutoSuggestion,
      {
        columnName: value,
        'date': DateTime.now().toString(),
      },
      where: '${LoginAutoSuggestionColumns.userId} = $userID',
    );
  }

  Future<void> replaceEmailWholeRow(userID, phone, email, id) async {
    final db = await instance.database;
    await db.update(
        tableNameLoginAutoSuggestion,
        {
          'userId': userID,
          'phone': phone,
          'email': email,
          'date': '${DateTime.now()}',
        },
        where: '${LoginAutoSuggestionColumns.id} = ?',
        whereArgs: [id]);
  }

  addWaterToLocalDB(MyWaterDatabaseModel waterDatabaseModel) async {
    try {
      final db = await instance.database;
      final result =
          await db.insert(waterTableName, waterDatabaseModel.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  Future<List<MyWaterDatabaseModel>> fetchWaterCupData(userID) async {
    final db = await instance.database;
    final result = await db
        .rawQuery('SELECT * FROM $waterTableName WHERE userID = ?', [userID]);
    return result.map((json) => MyWaterDatabaseModel.fromJson(json)).toList();
  }

  Future<void> updateStatusForUser(String userId, String rowIdToUpdate) async {
    final db = await database;
    await db.execute(
      'UPDATE $waterTableName SET ${MyWaterDatabaseColumns.status} = (CASE WHEN ${MyWaterDatabaseColumns.id} = ? THEN \'1\' ELSE \'0\' END) WHERE ${MyWaterDatabaseColumns.userID} = ?',
      [rowIdToUpdate.toString(), userId.toString()],
    );
  }

  Future<String> getWaterValue(userID) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT water FROM $waterTableName WHERE userID = $userID AND status = 1',
    );
    return result.first['water'] as String;
  }
}
