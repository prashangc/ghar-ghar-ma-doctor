class LabBookingResponseModel {
  int? memberId;
  int? serviceId;
  String? date;
  String? time;
  int? status;
  String? bookingStatus;
  String? updatedAt;
  String? createdAt;
  int? id;

  LabBookingResponseModel(
      {this.memberId,
      this.serviceId,
      this.date,
      this.time,
      this.status,
      this.bookingStatus,
      this.updatedAt,
      this.createdAt,
      this.id});

  LabBookingResponseModel.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    serviceId = json['service_id'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    bookingStatus = json['booking_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['member_id'] = memberId;
    data['service_id'] = serviceId;
    data['date'] = date;
    data['time'] = time;
    data['status'] = status;
    data['booking_status'] = bookingStatus;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
