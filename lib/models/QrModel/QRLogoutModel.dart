class QRLogoutModel {
  String? tokenId;

  QRLogoutModel({this.tokenId});

  QRLogoutModel.fromJson(Map<String, dynamic> json) {
    tokenId = json['token_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token_id'] = tokenId;
    return data;
  }
}
