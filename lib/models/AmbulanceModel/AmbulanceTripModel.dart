class AmbulanceTripModel {
  int? id;
  String? date;
  String? startTime;
  String? endTime;
  int? notificationId;
  int? driverId;
  int? userId;
  String? patientName;
  String? patientNumber;
  String? visitorName;
  String? visitorNumber;
  int? ambulamceFareId;
  int? medicalSupport;
  int? totalKmCovered;
  String? totalTimeConsumed;
  String? paymentDate;
  int? paymentAmount;
  String? paymentMethod;
  int? extendedTotalKmCovered;
  String? extendedTotalTimeConsumed;
  int? extendedPaymentAmount;
  String? extendedPaymentMethod;
  int? status;
  String? driverSourceLongitude;
  String? driverSourceLatitude;
  String? destinationLongitude;
  String? destinationLatitude;
  String? extendedLongitude;
  String? extendedLatitude;
  String? createdAt;
  String? updatedAt;
  UserAddress? userAddress;
  AmbulanceFare? ambulanceFare;
  String? driverKey;
  String? userKey;

  AmbulanceTripModel(
      {this.id,
      this.date,
      this.startTime,
      this.endTime,
      this.notificationId,
      this.driverId,
      this.userId,
      this.patientName,
      this.patientNumber,
      this.visitorName,
      this.visitorNumber,
      this.ambulamceFareId,
      this.medicalSupport,
      this.totalKmCovered,
      this.totalTimeConsumed,
      this.paymentDate,
      this.paymentAmount,
      this.paymentMethod,
      this.extendedTotalKmCovered,
      this.extendedTotalTimeConsumed,
      this.extendedPaymentAmount,
      this.extendedPaymentMethod,
      this.status,
      this.driverSourceLongitude,
      this.driverSourceLatitude,
      this.destinationLongitude,
      this.destinationLatitude,
      this.extendedLongitude,
      this.extendedLatitude,
      this.createdAt,
      this.updatedAt,
      this.userAddress,
      this.ambulanceFare,
      this.driverKey,
      this.userKey});

  AmbulanceTripModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    notificationId = json['notification_id'];
    driverId = json['driver_id'];
    userId = json['user_id'];
    patientName = json['patient_name'];
    patientNumber = json['patient_number'];
    visitorName = json['visitor_name'];
    visitorNumber = json['visitor_number'];
    ambulamceFareId = json['ambulamce_fare_id'];
    medicalSupport = json['medical_support'];
    totalKmCovered = json['total_km_covered'];
    totalTimeConsumed = json['total_time_consumed'];
    paymentDate = json['payment_date'];
    paymentAmount = json['payment_amount'];
    paymentMethod = json['payment_method'];
    extendedTotalKmCovered = json['extended_total_km_covered'];
    extendedTotalTimeConsumed = json['extended_total_time_consumed'];
    extendedPaymentAmount = json['extended_payment_amount'];
    extendedPaymentMethod = json['extended_payment_method'];
    status = json['status'];
    driverSourceLongitude = json['driver_source_longitude'];
    driverSourceLatitude = json['driver_source_latitude'];
    destinationLongitude = json['destination_longitude'];
    destinationLatitude = json['destination_latitude'];
    extendedLongitude = json['extended_longitude'];
    extendedLatitude = json['extended_latitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userAddress = json['user_address'] != null
        ? UserAddress.fromJson(json['user_address'])
        : null;
    ambulanceFare = json['ambulance_fare'] != null
        ? AmbulanceFare.fromJson(json['ambulance_fare'])
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
    data['patient_name'] = patientName;
    data['patient_number'] = patientNumber;
    data['visitor_name'] = visitorName;
    data['visitor_number'] = visitorNumber;
    data['ambulamce_fare_id'] = ambulamceFareId;
    data['medical_support'] = medicalSupport;
    data['total_km_covered'] = totalKmCovered;
    data['total_time_consumed'] = totalTimeConsumed;
    data['payment_date'] = paymentDate;
    data['payment_amount'] = paymentAmount;
    data['payment_method'] = paymentMethod;
    data['extended_total_km_covered'] = extendedTotalKmCovered;
    data['extended_total_time_consumed'] = extendedTotalTimeConsumed;
    data['extended_payment_amount'] = extendedPaymentAmount;
    data['extended_payment_method'] = extendedPaymentMethod;
    data['status'] = status;
    data['driver_source_longitude'] = driverSourceLongitude;
    data['driver_source_latitude'] = driverSourceLatitude;
    data['destination_longitude'] = destinationLongitude;
    data['destination_latitude'] = destinationLatitude;
    data['extended_longitude'] = extendedLongitude;
    data['extended_latitude'] = extendedLatitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (userAddress != null) {
      data['user_address'] = userAddress!.toJson();
    }
    if (ambulanceFare != null) {
      data['ambulance_fare'] = ambulanceFare!.toJson();
    }
    data['driver_key'] = driverKey;
    data['user_key'] = userKey;
    return data;
  }
}

class UserAddress {
  int? id;
  String? pickUpLatitude;
  String? pickUpLongitude;

  UserAddress({this.id, this.pickUpLatitude, this.pickUpLongitude});

  UserAddress.fromJson(Map<String, dynamic> json) {
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

class AmbulanceFare {
  int? id;
  int? baseRate;
  int? amountPerKmPerHr;
  int? amountPerMinute;
  String? createdAt;
  String? updatedAt;

  AmbulanceFare(
      {this.id,
      this.baseRate,
      this.amountPerKmPerHr,
      this.amountPerMinute,
      this.createdAt,
      this.updatedAt});

  AmbulanceFare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    baseRate = json['base_rate'];
    amountPerKmPerHr = json['amount_per_km_per_hr'];
    amountPerMinute = json['amount_per_minute'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['base_rate'] = baseRate;
    data['amount_per_km_per_hr'] = amountPerKmPerHr;
    data['amount_per_minute'] = amountPerMinute;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
