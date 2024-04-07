class GymPackagesModel {
  int? id;
  int? vendorId;
  int? fitnessNameId;
  int? oneMonth;
  int? threeMonth;
  int? sixMonth;
  int? oneYear;
  String? createdAt;
  String? updatedAt;
  Fitnesstype? fitnesstype;

  GymPackagesModel(
      {this.id,
      this.vendorId,
      this.fitnessNameId,
      this.oneMonth,
      this.threeMonth,
      this.sixMonth,
      this.oneYear,
      this.createdAt,
      this.updatedAt,
      this.fitnesstype});

  GymPackagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    fitnessNameId = json['fitness_name_id'];
    oneMonth = json['one_month'];
    threeMonth = json['three_month'];
    sixMonth = json['six_month'];
    oneYear = json['one_year'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fitnesstype = json['fitnesstype'] != null
        ? Fitnesstype.fromJson(json['fitnesstype'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['fitness_name_id'] = fitnessNameId;
    data['one_month'] = oneMonth;
    data['three_month'] = threeMonth;
    data['six_month'] = sixMonth;
    data['one_year'] = oneYear;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (fitnesstype != null) {
      data['fitnesstype'] = fitnesstype!.toJson();
    }
    return data;
  }
}

class Fitnesstype {
  int? id;
  int? vendorId;
  String? fitnessName;
  String? createdAt;
  String? updatedAt;

  Fitnesstype(
      {this.id,
      this.vendorId,
      this.fitnessName,
      this.createdAt,
      this.updatedAt});

  Fitnesstype.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    fitnessName = json['fitness_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['fitness_name'] = fitnessName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
