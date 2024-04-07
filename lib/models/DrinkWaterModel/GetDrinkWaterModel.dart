class GetDrinkWaterModel {
  int? id;
  int? memberId;
  num? waterIntake;
  String? startTime;
  String? endTime;
  int? interval;
  int? notificationStatus;
  String? intervalUnit;
  String? createdAt;
  String? updatedAt;
  List<Days>? days;

  GetDrinkWaterModel(
      {this.id,
      this.memberId,
      this.waterIntake,
      this.startTime,
      this.endTime,
      this.interval,
      this.intervalUnit,
      this.notificationStatus,
      this.createdAt,
      this.updatedAt,
      this.days});

  GetDrinkWaterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    waterIntake = json['water_intake'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    interval = json['interval'];
    intervalUnit = json['interval_unit'];
    notificationStatus = json['notification_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(Days.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['water_intake'] = waterIntake;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['interval'] = interval;
    data['interval_unit'] = intervalUnit;
    data['notification_status'] = notificationStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (days != null) {
      data['days'] = days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Days {
  int? id;
  int? intakeId;
  String? day;
  num? intake;
  num? lastWeekIntake;
  String? createdAt;
  String? updatedAt;

  Days(
      {this.id,
      this.intakeId,
      this.day,
      this.intake,
      this.lastWeekIntake,
      this.createdAt,
      this.updatedAt});

  Days.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    intakeId = json['intake_id'];
    day = json['day'];
    intake = json['intake'];
    lastWeekIntake = json['last_week_intake'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['intake_id'] = intakeId;
    data['day'] = day;
    data['intake'] = intake;
    data['last_week_intake'] = lastWeekIntake;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
