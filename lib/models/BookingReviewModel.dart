class BookingReviewModel {
  int? userId;
  int? bookingId;
  String? messages;
  int? doctorId;
  int? doctorServiceType;

  BookingReviewModel(
      {this.userId,
      this.bookingId,
      this.messages,
      this.doctorId,
      this.doctorServiceType});

  BookingReviewModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    bookingId = json['booking_id'];
    messages = json['messages'];
    doctorId = json['doctor_id'];
    doctorServiceType = json['doctor_service_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['booking_id'] = bookingId;
    data['messages'] = messages;
    data['doctor_id'] = doctorId;
    data['doctor_service_type'] = doctorServiceType;
    return data;
  }
}
