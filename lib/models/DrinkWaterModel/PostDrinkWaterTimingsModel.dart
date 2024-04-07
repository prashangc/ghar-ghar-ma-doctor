class PostDrinkWaterTimingsModel {
  num? waterIntake;
  String? startTime;
  String? endTime;
  int? interval;
  int? notificationStatus;
  String? intervalUnit;

  PostDrinkWaterTimingsModel(
      {this.waterIntake,
      this.startTime,
      this.endTime,
      this.interval,
      this.notificationStatus,
      this.intervalUnit});

  PostDrinkWaterTimingsModel.fromJson(Map<String, dynamic> json) {
    waterIntake = json['water_intake'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    interval = json['interval'];
    notificationStatus = json['notification_status'];
    intervalUnit = json['interval_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['water_intake'] = waterIntake;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['interval'] = interval;
    data['notification_status'] = notificationStatus;
    data['interval_unit'] = intervalUnit;
    return data;
  }
}
