class SendRequestToDriver {
  int? driverId;
  String? pickUpLongitude;
  String? pickUpLatitude;

  SendRequestToDriver(
      {this.driverId, this.pickUpLongitude, this.pickUpLatitude});

  SendRequestToDriver.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    pickUpLongitude = json['pick_up_longitude'];
    pickUpLatitude = json['pick_up_latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver_id'] = driverId;
    data['pick_up_longitude'] = pickUpLongitude;
    data['pick_up_latitude'] = pickUpLatitude;
    return data;
  }
}
