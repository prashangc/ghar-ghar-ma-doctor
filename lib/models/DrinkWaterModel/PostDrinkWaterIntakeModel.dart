class PostDrinkWaterIntakeModel {
  double? intake;

  PostDrinkWaterIntakeModel({this.intake});

  PostDrinkWaterIntakeModel.fromJson(Map<String, dynamic> json) {
    intake = json['intake'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['intake'] = intake;
    return data;
  }
}
