class PackageImageSliderModel {
  int? id;
  String? slug;
  String? bannerTitle;
  String? bannerBody;
  String? image;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  PackageImageSliderModel(
      {this.id,
      this.slug,
      this.bannerTitle,
      this.bannerBody,
      this.image,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  PackageImageSliderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    bannerTitle = json['banner_title'];
    bannerBody = json['banner_body'];
    image = json['image'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['banner_title'] = bannerTitle;
    data['banner_body'] = bannerBody;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
