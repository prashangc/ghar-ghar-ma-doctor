class RefreshTokenResponseModel {
  String? message;
  String? refreshToken;

  RefreshTokenResponseModel({this.message, this.refreshToken});

  RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['refresh_token'] = refreshToken;
    return data;
  }
}
