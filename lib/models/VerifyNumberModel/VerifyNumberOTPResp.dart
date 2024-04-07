class VerifyNumberOTPResp {
  String? message;
  int? otp;

  VerifyNumberOTPResp({this.message, this.otp});

  VerifyNumberOTPResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['otp'] = otp;
    return data;
  }
}
