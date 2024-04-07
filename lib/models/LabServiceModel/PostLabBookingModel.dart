class PostLabBookingModel {
  int? labtestId;
  int? labProfileId;
  String? date;
  String? time;
  String? price;

  PostLabBookingModel(
      {this.labtestId, this.labProfileId, this.date, this.time, this.price});

  PostLabBookingModel.fromJson(Map<String, dynamic> json) {
    labtestId = json['labtest_id'];
    labtestId = json['labprofile_id'];
    date = json['date'];
    time = json['time'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['labtest_id'] = labtestId;
    data['labprofile_id'] = labProfileId;
    data['date'] = date;
    data['time'] = time;
    data['price'] = price;
    return data;
  }
}
