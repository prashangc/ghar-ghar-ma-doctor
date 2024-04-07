import 'package:ghargharmadoctor/local_database/CartDatabaseModel.dart';

class MyShippingDetailsModel {
  List<MyCartDatabaseModel>? CartDatabaseModel;
  String? district;
  String? area;
  String? subArea;
  String? street;
  String? totalAmount;
  String? deliveryCharge;

  MyShippingDetailsModel({
    this.CartDatabaseModel,
    this.district,
    this.area,
    this.subArea,
    this.street,
    this.totalAmount,
    this.deliveryCharge,
  });
}
