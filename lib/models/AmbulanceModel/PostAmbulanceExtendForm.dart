class PostAmbulanceExtendForm {
  String? extendedTotalKmCovered;
  String? extendedTotalTimeConsumed;
  String? extendedLongitude;
  String? extendedLatitude;
  String? extendedPaymentMethod;
  String? extendedPaymentAmount;
  int? id;

  PostAmbulanceExtendForm(
      {this.extendedTotalKmCovered,
      this.extendedTotalTimeConsumed,
      this.extendedLongitude,
      this.extendedLatitude,
      this.id,
      this.extendedPaymentMethod,
      this.extendedPaymentAmount});

  PostAmbulanceExtendForm.fromJson(Map<String, dynamic> json) {
    extendedTotalKmCovered = json['extended_total_km_covered'];
    extendedTotalTimeConsumed = json['extended_total_time_consumed'];
    extendedLongitude = json['extended_longitude'];
    id = json['id'];
    extendedLatitude = json['extended_latitude'];
    extendedPaymentMethod = json['extended_payment_method'];
    extendedPaymentAmount = json['extended_payment_amount '];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['extended_total_km_covered'] = extendedTotalKmCovered;
    data['extended_total_time_consumed'] = extendedTotalTimeConsumed;
    data['extended_longitude'] = extendedLongitude;
    data['extended_latitude'] = extendedLatitude;
    data['id'] = id;
    data['extended_payment_method'] = extendedPaymentMethod;
    data['extended_payment_amount '] = extendedPaymentAmount;
    return data;
  }
}
