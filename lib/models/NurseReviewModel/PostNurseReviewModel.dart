class PostNurseReviewModel {
  int? nurseId;
  int? appointmentId;
  String? rating;
  String? comment;

  PostNurseReviewModel(
      {this.nurseId, this.appointmentId, this.rating, this.comment});

  PostNurseReviewModel.fromJson(Map<String, dynamic> json) {
    nurseId = json['nurse_id'];
    appointmentId = json['appointment_id'];
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nurse_id'] = nurseId;
    data['appointment_id'] = appointmentId;
    data['rating'] = rating;
    data['comment'] = comment;
    return data;
  }
}
