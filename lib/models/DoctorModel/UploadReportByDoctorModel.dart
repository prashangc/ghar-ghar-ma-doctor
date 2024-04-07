class UploadReportByDoctorModel {
  String? history;
  String? examination;
  String? progress;
  String? followUpDate;
  String? treatment;
  String? image;

  UploadReportByDoctorModel(
      {this.history,
      this.examination,
      this.progress,
      this.followUpDate,
      this.treatment,
      this.image});

  UploadReportByDoctorModel.fromJson(Map<String, dynamic> json) {
    history = json['history'];
    examination = json['examination'];
    progress = json['progress'];
    followUpDate = json['followUpDate'];
    treatment = json['treatment'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['history'] = history;
    data['examination'] = examination;
    data['progress'] = progress;
    data['followUpDate'] = followUpDate;
    data['treatment'] = treatment;
    data['image'] = image;
    return data;
  }
}
