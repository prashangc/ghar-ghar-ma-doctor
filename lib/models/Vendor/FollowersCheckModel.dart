class FollowersCheckModel {
  int? isfollowed;

  FollowersCheckModel({this.isfollowed});

  FollowersCheckModel.fromJson(Map<String, dynamic> json) {
    isfollowed = json['isfollowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isfollowed'] = isfollowed;
    return data;
  }
}
