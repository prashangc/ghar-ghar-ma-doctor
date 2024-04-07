import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/UserDetailsDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/myDB.dart';

// List<UserDetailsDatabaseModel> userDetailsDatabaseModel = [];

Future getUserDetailsFromDB() async {
  int userID = int.parse(sharedPrefs.getFromDevice('userID'));
  List<UserDetailsDatabaseModel> userDetailsDatabaseModel =
      await MyDatabase.instance.fetchDataFromUserDetails(userID);
  return userDetailsDatabaseModel;
}
