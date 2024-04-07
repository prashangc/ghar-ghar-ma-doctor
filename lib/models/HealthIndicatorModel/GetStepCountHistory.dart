class GetStepCountHistory {
  int? id;
  int? memberId;
  int? week;
  int? totalStepCount;
  int? totalCredit;
  String? createdAt;
  String? updatedAt;
  List<MyStepCount>? step;

  GetStepCountHistory(
      {this.id,
      this.memberId,
      this.week,
      this.totalStepCount,
      this.totalCredit,
      this.createdAt,
      this.updatedAt,
      this.step});

  GetStepCountHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    week = json['week'];
    totalStepCount = json['total_step_count'];
    totalCredit = json['total_credit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['step'] != null) {
      step = <MyStepCount>[];
      json['step'].forEach((v) {
        step!.add(MyStepCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['week'] = week;
    data['total_step_count'] = totalStepCount;
    data['total_credit'] = totalCredit;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (step != null) {
      data['step'] = step!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyStepCount {
  int? id;
  int? stepcountId;
  String? day;
  int? stepCount;
  int? credit;
  String? createdAt;
  String? updatedAt;

  MyStepCount(
      {this.id,
      this.stepcountId,
      this.day,
      this.stepCount,
      this.credit,
      this.createdAt,
      this.updatedAt});

  MyStepCount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stepcountId = json['stepcount_id'];
    day = json['day'];
    stepCount = json['step_count'];
    credit = json['credit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stepcount_id'] = stepcountId;
    data['day'] = day;
    data['step_count'] = stepCount;
    data['credit'] = credit;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
