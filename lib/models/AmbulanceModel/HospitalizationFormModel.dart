class HospitalizationFormModel {
  String? hospitalizationFile;
  String? hospitalName;
  String? doctorName;

  HospitalizationFormModel(
      {this.hospitalizationFile, this.hospitalName, this.doctorName});

  HospitalizationFormModel.fromJson(Map<String, dynamic> json) {
    hospitalizationFile = json['hospitalization_file'];
    hospitalName = json['hospital_name'];
    doctorName = json['doctor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hospitalization_file'] = hospitalizationFile;
    data['hospital_name'] = hospitalName;
    data['doctor_name'] = doctorName;
    return data;
  }
}
