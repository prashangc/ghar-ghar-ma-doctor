class OTPResponseModel {
  String? message;
  int? oTP;

  OTPResponseModel({this.message, this.oTP});

  OTPResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    oTP = json['OTP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['OTP'] = oTP;
    return data;
  }
}
