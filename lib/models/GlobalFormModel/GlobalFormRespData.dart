class GlobalFormRespData {
  String? status;
  int? kycId;

  GlobalFormRespData({this.status, this.kycId});

  GlobalFormRespData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    kycId = json['kyc_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['kyc_id'] = kycId;
    return data;
  }
}
