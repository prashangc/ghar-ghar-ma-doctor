class PostRescheduleScreeningModel {
  int? userpackageId;
  int? screeningdateId;
  String? date;
  String? time;

  PostRescheduleScreeningModel(
      {this.userpackageId, this.screeningdateId, this.date, this.time});

  PostRescheduleScreeningModel.fromJson(Map<String, dynamic> json) {
    userpackageId = json['userpackage_id'];
    screeningdateId = json['screeningdate_id'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userpackage_id'] = userpackageId;
    data['screeningdate_id'] = screeningdateId;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
