import 'package:ghargharmadoctor/local_database/CartDatabaseModel.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAllDoctorsModel.dart';
import 'package:ghargharmadoctor/models/NurseModel/AlNurseModel.dart';
import 'package:ghargharmadoctor/models/models.dart';

class GuestLoginNavigationModel {
  final dynamic amount;
  final PackagesModel? packagesModel;
  final List<MyCartDatabaseModel>? buyProduct;
  final AllNurseModel? allNurseModel;
  final String? yourProblem;
  final String? dateValue;
  final String? shiftValue;
  final String? totalAmount;
  final int? selectedTimeShiftID;
  final Doctors? doctors;
  final String? timeUniqueID;
  MyCartDatabaseModel? myCart;
  GuestLoginNavigationModel({
    this.amount,
    this.packagesModel,
    this.buyProduct,
    this.allNurseModel,
    this.dateValue,
    this.selectedTimeShiftID,
    this.yourProblem,
    this.shiftValue,
    this.totalAmount,
    this.doctors,
    this.timeUniqueID,
    this.myCart,
  });
}
