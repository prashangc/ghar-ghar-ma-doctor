class AddRelationModel {
  String? familyRelation;

  AddRelationModel({this.familyRelation});

  AddRelationModel.fromJson(Map<String, dynamic> json) {
    familyRelation = json['family_relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['family_relation'] = familyRelation;
    return data;
  }
}
