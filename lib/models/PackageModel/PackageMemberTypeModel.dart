class PackageMemberTypeModel {
  final int id;
  final String name;

  PackageMemberTypeModel({required this.id, required this.name});
}

List<PackageMemberTypeModel> packageMemberTypeList = [
  PackageMemberTypeModel(
    id: 1,
    name: 'New Member',
  ),
  PackageMemberTypeModel(
    id: 2,
    name: 'Existing Member',
  ),
];
