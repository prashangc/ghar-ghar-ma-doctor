class DocumentTypeModel {
  final String? textValue;
  DocumentTypeModel({
    required this.textValue,
  });
}

List<DocumentTypeModel> documentTypeList = [
  DocumentTypeModel(
    textValue: 'Citizenship',
  ),
  DocumentTypeModel(
    textValue: 'Driving License',
  ),
  DocumentTypeModel(
    textValue: 'Passport',
  ),
  DocumentTypeModel(
    textValue: 'Voter Card',
  ),
  DocumentTypeModel(
    textValue: 'National Identity Card',
  ),
  DocumentTypeModel(
    textValue: 'Non-Resident Nepali Identity Card',
  ),
  DocumentTypeModel(
    textValue: 'Other',
  ),
];
