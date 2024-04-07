class PostDeathClaimInsuranceModel {
  int? userID;
  int? packageInsuranceID;
  double? claimAmount;
  String? handWrittenLetter;
  String? medicalReport;
  String? invoice;

  PostDeathClaimInsuranceModel(
      {this.packageInsuranceID,
      this.claimAmount,
      this.userID,
      this.handWrittenLetter,
      this.medicalReport,
      this.invoice});

  PostDeathClaimInsuranceModel.fromJson(Map<String, dynamic> json) {
    userID = json['user_id'];
    packageInsuranceID = json['package_insurance_id'];
    claimAmount = json['claim_amount'];
    handWrittenLetter = json['hand_written_letter'];
    medicalReport = json['medical_report'];
    invoice = json['invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userID;
    data['package_insurance_id'] = packageInsuranceID;
    data['claim_amount'] = claimAmount;
    data['hand_written_letter'] = handWrittenLetter;
    data['medical_report'] = medicalReport;
    data['invoice'] = invoice;
    return data;
  }
}
