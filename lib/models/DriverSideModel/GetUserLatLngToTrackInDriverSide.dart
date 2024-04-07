class GetUserLatLngToTrackInDriverSide {
  int? id;
  String? date;
  String? startTime;
  String? endTime;
  int? notificationId;
  int? driverId;
  int? userId;
  int? status;
  String? driverSourceLongitude;
  String? driverSourceLatitude;
  String? createdAt;
  String? updatedAt;
  UserAddressDetails? userAddress;
  String? driverKey;
  String? userKey;

  GetUserLatLngToTrackInDriverSide(
      {this.id,
      this.date,
      this.startTime,
      this.endTime,
      this.notificationId,
      this.driverId,
      this.userId,
      this.status,
      this.driverSourceLongitude,
      this.driverSourceLatitude,
      this.createdAt,
      this.updatedAt,
      this.userAddress,
      this.driverKey,
      this.userKey});

  GetUserLatLngToTrackInDriverSide.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    notificationId = json['notification_id'];
    driverId = json['driver_id'];
    userId = json['user_id'];
    status = json['status'];
    driverSourceLongitude = json['driver_source_longitude'];
    driverSourceLatitude = json['driver_source_latitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userAddress = json['user_address'] != null
        ? UserAddressDetails.fromJson(json['user_address'])
        : null;
    driverKey = json['driver_key'];
    userKey = json['user_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['notification_id'] = notificationId;
    data['driver_id'] = driverId;
    data['user_id'] = userId;
    data['status'] = status;
    data['driver_source_longitude'] = driverSourceLongitude;
    data['driver_source_latitude'] = driverSourceLatitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (userAddress != null) {
      data['user_address'] = userAddress!.toJson();
    }
    data['driver_key'] = driverKey;
    data['user_key'] = userKey;
    return data;
  }
}

class UserAddressDetails {
  int? id;
  String? pickUpLatitude;
  String? pickUpLongitude;

  UserAddressDetails({this.id, this.pickUpLatitude, this.pickUpLongitude});

  UserAddressDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickUpLatitude = json['pick_up_latitude'];
    pickUpLongitude = json['pick_up_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pick_up_latitude'] = pickUpLatitude;
    data['pick_up_longitude'] = pickUpLongitude;
    return data;
  }
}
