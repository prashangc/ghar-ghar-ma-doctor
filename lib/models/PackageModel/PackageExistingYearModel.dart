class PackageExistingYearModel {
  final int id;
  final String name;

  PackageExistingYearModel({required this.id, required this.name});
}

List<PackageExistingYearModel> packageExistingYearList = [
  PackageExistingYearModel(
    id: 1,
    name: 'Year 2',
  ),
  PackageExistingYearModel(
    id: 2,
    name: 'Year 3 & Onwards',
  ),
];
