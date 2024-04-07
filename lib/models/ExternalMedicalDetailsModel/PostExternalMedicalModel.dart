class PostExternalMedicalDetailsModel {
  List<String>? report;

  PostExternalMedicalDetailsModel({this.report});

  PostExternalMedicalDetailsModel.fromJson(Map<String, dynamic> json) {
    report = json['report'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['report'] = report;
    return data;
  }
}
