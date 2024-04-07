class PostDoctorTimingsModel {
  String? date;
  String? startTime;
  String? endTime;
  String? limit;
  String? hospital;
  String? serviceType;

  PostDoctorTimingsModel(
      {this.date,
      this.startTime,
      this.endTime,
      this.limit,
      this.hospital,
      this.serviceType});

  PostDoctorTimingsModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    limit = json['limit'];
    hospital = json['lihospitalmit'];
    serviceType = json['service_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['limit'] = limit;
    data['hospital'] = hospital;
    data['service_type'] = serviceType;
    return data;
  }
}
