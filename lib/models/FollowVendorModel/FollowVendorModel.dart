class FollowVendorModel {
  int? vendorId;

  FollowVendorModel({this.vendorId});

  FollowVendorModel.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendor_id'] = vendorId;
    return data;
  }
}
