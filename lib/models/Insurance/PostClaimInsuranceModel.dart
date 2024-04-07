class PostClaimInsuranceModel {
  int? insuranceId;
  double? claimAmount;
  String? handWrittenLetter;
  String? medicalReport;
  String? invoice;

  PostClaimInsuranceModel(
      {this.insuranceId,
      this.claimAmount,
      this.handWrittenLetter,
      this.medicalReport,
      this.invoice});

  PostClaimInsuranceModel.fromJson(Map<String, dynamic> json) {
    insuranceId = json['package_insurance_id'];
    claimAmount = json['claim_amount'];
    handWrittenLetter = json['hand_written_letter'];
    medicalReport = json['medical_report'];
    invoice = json['invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['package_insurance_id'] = insuranceId;
    data['claim_amount'] = claimAmount;
    data['hand_written_letter'] = handWrittenLetter;
    data['medical_report'] = medicalReport;
    data['invoice'] = invoice;
    return data;
  }
}
