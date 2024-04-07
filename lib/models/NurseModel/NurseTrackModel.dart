class NurseTrackModel {
  int? id;
  String? slug;
  String? bookingStatus;

  NurseTrackModel({this.id, this.slug, this.bookingStatus});

  NurseTrackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    bookingStatus = json['booking_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['booking_status'] = bookingStatus;
    return data;
  }
}
