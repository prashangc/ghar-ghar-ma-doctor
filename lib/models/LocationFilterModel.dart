class LocationFilterModel {
  final String? textValue;
  LocationFilterModel({required this.textValue});
}

List<LocationFilterModel> locationList = [
  LocationFilterModel(textValue: 'My\nAddress'),
  LocationFilterModel(textValue: 'Near\nMe'),
  LocationFilterModel(textValue: 'Select\nLocation'),
];
