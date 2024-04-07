class OurServicesModel {
  int? id;
  String? slug;
  String? serviceTitle;
  String? shortDescription;
  String? longDescription;
  String? image;
  String? imagePath;
  String? icon;
  String? iconPath;
  String? createdAt;
  String? updatedAt;

  OurServicesModel(
      {this.id,
      this.slug,
      this.serviceTitle,
      this.shortDescription,
      this.longDescription,
      this.image,
      this.imagePath,
      this.icon,
      this.iconPath,
      this.createdAt,
      this.updatedAt});

  OurServicesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    serviceTitle = json['service_title'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
    image = json['image'];
    imagePath = json['image_path'];
    icon = json['icon'];
    iconPath = json['icon_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['service_title'] = serviceTitle;
    data['short_description'] = shortDescription;
    data['long_description'] = longDescription;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['icon'] = icon;
    data['icon_path'] = iconPath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
