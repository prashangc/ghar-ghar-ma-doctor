class DoctorBookingResponseModel {
  int? userId;
  int? bookingId;
  int? doctorId;
  int? doctorServiceType;
  String? messages;
  String? slug;
  int? status;
  String? bookingStatus;
  String? updatedAt;
  String? createdAt;
  int? id;

  DoctorBookingResponseModel(
      {this.userId,
      this.bookingId,
      this.doctorId,
      this.doctorServiceType,
      this.messages,
      this.slug,
      this.status,
      this.bookingStatus,
      this.updatedAt,
      this.createdAt,
      this.id});

  DoctorBookingResponseModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    bookingId = json['booking_id'];
    doctorId = json['doctor_id'];
    doctorServiceType = json['doctor_service_type'];
    messages = json['messages'];
    slug = json['slug'];
    status = json['status'];
    bookingStatus = json['booking_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['booking_id'] = bookingId;
    data['doctor_id'] = doctorId;
    data['doctor_service_type'] = doctorServiceType;
    data['messages'] = messages;
    data['slug'] = slug;
    data['status'] = status;
    data['booking_status'] = bookingStatus;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
