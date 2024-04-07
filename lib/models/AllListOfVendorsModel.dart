class AllListOfVendorsModel {
  int? id;
  String? vendorType;
  String? createdAt;
  String? updatedAt;
  List<SubCategory>? category;

  AllListOfVendorsModel(
      {this.id,
      this.vendorType,
      this.createdAt,
      this.updatedAt,
      this.category});

  AllListOfVendorsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorType = json['vendor_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['category'] != null) {
      category = <SubCategory>[];
      json['category'].forEach((v) {
        category!.add(SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_type'] = vendorType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? parentId;
  int? vendorTypeId;
  int? featured;
  int? status;
  String? image;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  SubCategory(
      {this.id,
      this.name,
      this.slug,
      this.description,
      this.parentId,
      this.vendorTypeId,
      this.featured,
      this.status,
      this.image,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    parentId = json['parent_id'];
    vendorTypeId = json['vendor_type_id'];
    featured = json['featured'];
    status = json['status'];
    image = json['image'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['parent_id'] = parentId;
    data['vendor_type_id'] = vendorTypeId;
    data['featured'] = featured;
    data['status'] = status;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
