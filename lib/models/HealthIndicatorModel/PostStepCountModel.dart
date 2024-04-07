class PostStepCountModel {
  int? stepsCount;
  int? credit;

  PostStepCountModel({this.stepsCount, this.credit});

  PostStepCountModel.fromJson(Map<String, dynamic> json) {
    stepsCount = json['steps_count'];
    credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['steps_count'] = stepsCount;
    data['credit'] = credit;
    return data;
  }
}
