class NewsMenuModel {
  int? id;
  int? menuId;
  int? userId;
  String? titleEn;
  String? descriptionEn;
  String? image;
  String? imagePath;
  String? slug;
  int? position;
  String? code;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<Children>? children;

  NewsMenuModel(
      {this.id,
      this.menuId,
      this.userId,
      this.titleEn,
      this.descriptionEn,
      this.image,
      this.imagePath,
      this.slug,
      this.position,
      this.code,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.children});

  NewsMenuModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuId = json['menu_id'];
    userId = json['user_id'];
    titleEn = json['title_en'];
    descriptionEn = json['description_en'];
    image = json['image'];
    imagePath = json['image_path'];
    slug = json['slug'];
    position = json['position'];
    code = json['code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['menu_id'] = menuId;
    data['user_id'] = userId;
    data['title_en'] = titleEn;
    data['description_en'] = descriptionEn;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['slug'] = slug;
    data['position'] = position;
    data['code'] = code;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Children {
  int? id;
  int? menuId;
  int? userId;
  String? titleEn;
  String? descriptionEn;
  String? image;
  String? imagePath;
  String? slug;
  int? position;
  String? code;
  int? status;
  String? createdAt;
  String? updatedAt;

  Children(
      {this.id,
      this.menuId,
      this.userId,
      this.titleEn,
      this.descriptionEn,
      this.image,
      this.imagePath,
      this.slug,
      this.position,
      this.code,
      this.status,
      this.createdAt,
      this.updatedAt});

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuId = json['menu_id'];
    userId = json['user_id'];
    titleEn = json['title_en'];
    descriptionEn = json['description_en'];
    image = json['image'];
    imagePath = json['image_path'];
    slug = json['slug'];
    position = json['position'];
    code = json['code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['menu_id'] = menuId;
    data['user_id'] = userId;
    data['title_en'] = titleEn;
    data['description_en'] = descriptionEn;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['slug'] = slug;
    data['position'] = position;
    data['code'] = code;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
