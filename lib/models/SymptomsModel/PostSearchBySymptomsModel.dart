class PostSearchBySymptomsModel {
  List<String>? symptoms;

  PostSearchBySymptomsModel({this.symptoms});

  PostSearchBySymptomsModel.fromJson(Map<String, dynamic> json) {
    symptoms = json['symptoms'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symptoms'] = symptoms;
    return data;
  }
}
