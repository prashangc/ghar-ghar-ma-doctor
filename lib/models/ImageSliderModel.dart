class ImageSliderModel {
  int? id;
  String? slug;
  int? vendorId;
  String? bannerTitle;
  String? bannerBody;
  String? image;
  String? imagePath;
  String? createdAt;
  String? updatedAt;
  Vendor? vendor;

  ImageSliderModel(
      {this.id,
      this.slug,
      this.vendorId,
      this.bannerTitle,
      this.bannerBody,
      this.image,
      this.imagePath,
      this.createdAt,
      this.updatedAt,
      this.vendor});

  ImageSliderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    vendorId = json['vendor_id'];
    bannerTitle = json['banner_title'];
    bannerBody = json['banner_body'];
    image = json['image'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['vendor_id'] = vendorId;
    data['banner_title'] = bannerTitle;
    data['banner_body'] = bannerBody;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    return data;
  }
}

class Vendor {
  int? id;
  int? vendorId;
  int? vendorType;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? address;
  String? slug;
  String? createdAt;
  String? updatedAt;

  Vendor(
      {this.id,
      this.vendorId,
      this.vendorType,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.address,
      this.slug,
      this.createdAt,
      this.updatedAt});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    vendorType = json['vendor_type'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    address = json['address'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['vendor_type'] = vendorType;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['address'] = address;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
