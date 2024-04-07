class DateModel {
  int? id;
  String? date;
  int? doctorId;

  DateModel({this.id, this.date, this.doctorId});

  DateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    doctorId = json['doctor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['doctor_id'] = doctorId;
    return data;
  }
}
