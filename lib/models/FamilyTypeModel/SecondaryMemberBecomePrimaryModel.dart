class SecondaryMemberBecomePrimaryModel {
  String? changeReason;
  String? familyRelation;
  String? deathCertificate;
  int? deathCase;

  SecondaryMemberBecomePrimaryModel(
      {this.changeReason,
      this.familyRelation,
      this.deathCertificate,
      this.deathCase});

  SecondaryMemberBecomePrimaryModel.fromJson(Map<String, dynamic> json) {
    changeReason = json['change_reason'];
    familyRelation = json['family_relation'];
    deathCertificate = json['death_certificate'];
    deathCase = json['death_case'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['change_reason'] = changeReason;
    data['family_relation'] = familyRelation;
    data['death_certificate'] = deathCertificate;
    data['death_case'] = deathCase;
    return data;
  }
}
