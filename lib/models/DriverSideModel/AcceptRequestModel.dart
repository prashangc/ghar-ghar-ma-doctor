class AcceptRequestModel {
  int? driverId;
  String? driverSourceLongitude;
  String? driverSourceLatitude;
  String? status;
  String? notificationID;

  AcceptRequestModel(
      {this.driverId,
      this.driverSourceLongitude,
      this.driverSourceLatitude,
      this.status,
      this.notificationID});

  AcceptRequestModel.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    driverSourceLongitude = json['driver_source_longitude'];
    driverSourceLatitude = json['driver_source_latitude'];
    status = json['status'];
    notificationID = json['notificationID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver_id'] = driverId;
    data['driver_source_longitude'] = driverSourceLongitude;
    data['driver_source_latitude'] = driverSourceLatitude;
    data['status'] = status;
    data['notification_id'] = notificationID;
    return data;
  }
}
