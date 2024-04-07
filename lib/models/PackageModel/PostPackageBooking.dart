class PostPackageBooking {
  int? packageId;
  int? renewStatus;
  int? year;

  PostPackageBooking({this.packageId, this.renewStatus, this.year});

  PostPackageBooking.fromJson(Map<String, dynamic> json) {
    packageId = json['package_id'];
    renewStatus = json['renew_status'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['package_id'] = packageId;
    data['renew_status'] = renewStatus;
    data['year'] = year;
    return data;
  }
}
