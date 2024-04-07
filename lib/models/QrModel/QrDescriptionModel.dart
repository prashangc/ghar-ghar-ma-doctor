class QrDescriptionModel {
  final String desc;
  QrDescriptionModel({
    required this.desc,
  });
}

List<QrDescriptionModel> qrDescriptionList = [
  QrDescriptionModel(
    desc:
        'Link your account to another device. One account can be only be linked with one device.',
  ),
  QrDescriptionModel(
    desc: 'Add members to your family. Scan QR to send family request.',
  ),
];
