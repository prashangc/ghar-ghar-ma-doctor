class PostAmbulanceBookingForm {
  String? patientName;
  String? patientNumber;
  int? medicalSupport;
  String? paymentMethod;
  String? token;
  String? destinationLongitude;
  String? destinationLatitude;
  int? paymentAmount;
  int? id;

  PostAmbulanceBookingForm(
      {this.patientName,
      this.patientNumber,
      this.medicalSupport,
      this.paymentAmount,
      this.token,
      this.destinationLongitude,
      this.destinationLatitude,
      this.id,
      this.paymentMethod});

  PostAmbulanceBookingForm.fromJson(Map<String, dynamic> json) {
    patientName = json['patient_name'];
    patientNumber = json['patient_number'];
    medicalSupport = json['medical_support'];
    paymentMethod = json['payment_method'];
    paymentAmount = json['payment_amount'];
    id = json['id'];
    token = json['token'];
    destinationLongitude = json['destination_longitude'];
    destinationLatitude = json['destination_latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_name'] = patientName;
    data['patient_number'] = patientNumber;
    data['medical_support'] = medicalSupport;
    data['payment_method'] = paymentMethod;
    data['id'] = id;
    data['destination_latitude'] = destinationLatitude;
    data['destination_longitude'] = destinationLongitude;
    data['payment_amount'] = paymentAmount;
    data['token'] = paymentAmount;
    return data;
  }
}
