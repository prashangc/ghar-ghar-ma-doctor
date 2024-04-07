class GetInsuranceDetailsModel {
  int? id;
  num? total;
  num? remaining;
  num? claimed;
  List<Insurance>? insurance;

  GetInsuranceDetailsModel(
      {this.id, this.total, this.remaining, this.claimed, this.insurance});

  GetInsuranceDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    remaining = json['remaining'];
    claimed = json['claimed'];
    if (json['insurance'] != null) {
      insurance = <Insurance>[];
      json['insurance'].forEach((v) {
        insurance!.add(Insurance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total'] = total;
    data['remaining'] = remaining;
    data['claimed'] = claimed;
    if (insurance != null) {
      data['insurance'] = insurance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Insurance {
  int? id;
  String? type;
  num? total;
  num? claimed;
  num? remaining;

  Insurance({this.id, this.type, this.total, this.claimed, this.remaining});

  Insurance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    total = json['total'];
    claimed = json['claimed'];
    remaining = json['remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['total'] = total;
    data['claimed'] = claimed;
    data['remaining'] = remaining;
    return data;
  }
}
