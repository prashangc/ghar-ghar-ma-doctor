class PostBloodPressure {
  String? upper;
  String? lower;

  PostBloodPressure({this.upper, this.lower});

  PostBloodPressure.fromJson(Map<String, dynamic> json) {
    upper = json['upper'];
    lower = json['cancel_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['upper'] = upper;
    data['lower'] = lower;
    return data;
  }
}
