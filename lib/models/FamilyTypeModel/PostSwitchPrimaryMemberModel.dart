class PostSwitchPrimaryMemberModel {
  int? newmemberId;
  String? changeReason;
  String? familyRelation;

  PostSwitchPrimaryMemberModel(
      {this.newmemberId, this.changeReason, this.familyRelation});

  PostSwitchPrimaryMemberModel.fromJson(Map<String, dynamic> json) {
    newmemberId = json['newmember_id'];
    changeReason = json['change_reason'];
    familyRelation = json['family_relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['newmember_id'] = newmemberId;
    data['change_reason'] = changeReason;
    data['family_relation'] = familyRelation;
    return data;
  }
}
