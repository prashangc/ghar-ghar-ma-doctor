class FamilyTypeModel {
  int? id;
  String? name;

  FamilyTypeModel({this.id, this.name});
}

List<FamilyTypeModel> familyTypeList = [
  FamilyTypeModel(id: 1, name: 'Primary Member'),
  FamilyTypeModel(id: 2, name: 'Dependent Member'),
];
