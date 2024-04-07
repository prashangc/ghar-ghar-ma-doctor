class RemoveFamilyModel {
  String? removeReason;

  RemoveFamilyModel({this.removeReason});

  RemoveFamilyModel.fromJson(Map<String, dynamic> json) {
    removeReason = json['remove_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remove_reason'] = removeReason;
    return data;
  }
}
