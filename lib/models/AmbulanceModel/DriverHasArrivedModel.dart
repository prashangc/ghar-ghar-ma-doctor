class DriverHasArrivedModel {
  String? status;
  int? driverId;

  DriverHasArrivedModel({this.status, this.driverId});

  DriverHasArrivedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    driverId = json['driver_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['driver_id'] = driverId;
    return data;
  }
}
