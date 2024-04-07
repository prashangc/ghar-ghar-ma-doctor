class NurseBookingResponseModel {
  String? slug;
  int? memberId;
  int? nurseshiftId;
  String? messages;
  int? status;
  String? bookingStatus;
  String? updatedAt;
  String? createdAt;
  int? id;

  NurseBookingResponseModel(
      {this.slug,
      this.memberId,
      this.nurseshiftId,
      this.messages,
      this.status,
      this.bookingStatus,
      this.updatedAt,
      this.createdAt,
      this.id});

  NurseBookingResponseModel.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    memberId = json['member_id'];
    nurseshiftId = json['nurseshift_id'];
    messages = json['messages'];
    status = json['status'];
    bookingStatus = json['booking_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slug'] = slug;
    data['member_id'] = memberId;
    data['nurseshift_id'] = nurseshiftId;
    data['messages'] = messages;
    data['status'] = status;
    data['booking_status'] = bookingStatus;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
