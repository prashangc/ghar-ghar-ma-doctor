class HospitalTypeModel {
  final String? typeValue;
  HospitalTypeModel({
    required this.typeValue,
  });
}

List<HospitalTypeModel> hospitalTypeList = [
  HospitalTypeModel(
    typeValue: 'Emergency\nHospital',
  ),
  HospitalTypeModel(
    typeValue: '24/7\nHospital',
  ),
  HospitalTypeModel(
    typeValue: 'CancerHospital',
  ),
  HospitalTypeModel(
    typeValue: 'ICU\nAmbulance',
  ),
  HospitalTypeModel(
    typeValue: 'ICU\nAmbulance',
  ),
];
