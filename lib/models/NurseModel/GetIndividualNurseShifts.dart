class GetIndividualNurseShifts {
  int? id;
  int? nurseId;
  String? shift;
  String? createdAt;
  String? updatedAt;
  String? date;

  GetIndividualNurseShifts(
      {this.id,
      this.nurseId,
      this.shift,
      this.createdAt,
      this.updatedAt,
      this.date});

  GetIndividualNurseShifts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nurseId = json['nurse_id'];
    shift = json['shift'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nurse_id'] = nurseId;
    data['shift'] = shift;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['date'] = date;
    return data;
  }
}
