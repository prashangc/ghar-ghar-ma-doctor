class CheckTokenModel {
  String? tokenId;

  CheckTokenModel({this.tokenId});

  CheckTokenModel.fromJson(Map<String, dynamic> json) {
    tokenId = json['token_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token_id'] = tokenId;
    return data;
  }
}
