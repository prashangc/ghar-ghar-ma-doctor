class PostDoctorReviewModel {
  int? doctorId;
  int? appointmentID;
  String? rating;
  String? comment;

  PostDoctorReviewModel({this.doctorId, this.appointmentID, this.rating, this.comment});

  PostDoctorReviewModel.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    appointmentID = json['appointment_id'];
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctor_id'] = doctorId;
    data['appointment_id'] = appointmentID;
    data['rating'] = rating;
    data['comment'] = comment;
    return data;
  }
}
