class PostNurseShiftsModel {
  String? date;
  String? shift;

  PostNurseShiftsModel({this.date, this.shift});

  PostNurseShiftsModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    shift = json['shift'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['shift'] = shift;
    return data;
  }
}
