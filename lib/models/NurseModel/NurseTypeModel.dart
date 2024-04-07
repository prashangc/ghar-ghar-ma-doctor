class NurseTypeModel {
  final int? id;
  final String? name;
  NurseTypeModel({
    required this.id,
    required this.name,
  });
}

List<NurseTypeModel> nurseTypeList = [
  NurseTypeModel(
    id: 1,
    name: 'GD Office Nurse',
  ),
  NurseTypeModel(
    id: 2,
    name: 'Homecare Nurse',
  ),
];
