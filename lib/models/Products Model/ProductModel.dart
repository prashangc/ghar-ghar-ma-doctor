class ProductModel {
  int? currentPage;
  List<ProductModelData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  ProductModel(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  ProductModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ProductModelData>[];
      json['data'].forEach((v) {
        data!.add(ProductModelData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class ProductModelData {
  int? id;
  String? productName;
  String? slug;
  String? unit;
  int? categoryId;
  String? image;
  String? imagePath;
  String? shortDesc;
  String? description;
  int? stock;
  int? featured;
  int? userId;
  int? vendorId;
  String? discountPercent;
  int? actualRate;
  int? salePrice;
  String? averageRating;
  int? totalReviews;
  int? brand;
  List<String>? tags;
  int? haveStock;
  String? sku;
  String? color;
  String? size;
  String? precaution;
  String? sideEffect;
  String? howToUse;
  String? drugType;
  int? views;
  String? createdAt;
  String? updatedAt;
  int? vendorType;
  List<Gallery>? gallery;
  ProductVendorDetails? vendorDetails;
  BrandDetail? brandDetail;

  ProductModelData(
      {this.id,
      this.productName,
      this.slug,
      this.unit,
      this.categoryId,
      this.image,
      this.imagePath,
      this.shortDesc,
      this.description,
      this.stock,
      this.featured,
      this.userId,
      this.vendorId,
      this.discountPercent,
      this.actualRate,
      this.salePrice,
      this.averageRating,
      this.totalReviews,
      this.brand,
      this.tags,
      this.haveStock,
      this.sku,
      this.color,
      this.size,
      this.precaution,
      this.sideEffect,
      this.howToUse,
      this.drugType,
      this.views,
      this.createdAt,
      this.updatedAt,
      this.vendorType,
      this.gallery,
      this.vendorDetails,
      this.brandDetail});

  ProductModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    slug = json['slug'];
    unit = json['unit'];
    categoryId = json['category_id'];
    image = json['image'];
    imagePath = json['image_path'];
    shortDesc = json['shortDesc'];
    description = json['description'];
    stock = json['stock'];
    featured = json['featured'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    discountPercent = json['discountPercent'];
    actualRate = json['actualRate'];
    salePrice = json['sale_price'];
    averageRating = json['averageRating'];
    totalReviews = json['totalReviews'];
    brand = json['brand'];
    tags = json['tags'] == null
        ? []
        : List<String>.from(json["tags"].map((x) => x));
    haveStock = json['have_stock'];
    sku = json['sku'];
    color = json['color'];
    size = json['size'];
    precaution = json['precaution'];
    sideEffect = json['side_effect'];
    howToUse = json['how_to_use'];
    drugType = json['drug_type'];
    views = json['views'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vendorType = json['vendor_type'];
    if (json['gallery'] != null) {
      gallery = <Gallery>[];
      json['gallery'].forEach((v) {
        gallery!.add(Gallery.fromJson(v));
      });
    }
    vendorDetails = json['vendor_details'] != null
        ? ProductVendorDetails.fromJson(json['vendor_details'])
        : null;
    brandDetail = json['brand_detail'] != null
        ? BrandDetail.fromJson(json['brand_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productName'] = productName;
    data['slug'] = slug;
    data['unit'] = unit;
    data['category_id'] = categoryId;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['shortDesc'] = shortDesc;
    data['description'] = description;
    data['stock'] = stock;
    data['featured'] = featured;
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['discountPercent'] = discountPercent;
    data['actualRate'] = actualRate;
    data['sale_price'] = salePrice;
    data['averageRating'] = averageRating;
    data['totalReviews'] = totalReviews;
    data['brand'] = brand;
    data['tags'] = tags;
    data['have_stock'] = haveStock;
    data['sku'] = sku;
    data['color'] = color;
    data['size'] = size;
    data['precaution'] = precaution;
    data['side_effect'] = sideEffect;
    data['how_to_use'] = howToUse;
    data['drug_type'] = drugType;
    data['views'] = views;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['vendor_type'] = vendorType;
    if (gallery != null) {
      data['gallery'] = gallery!.map((v) => v.toJson()).toList();
    }
    if (vendorDetails != null) {
      data['vendor_details'] = vendorDetails!.toJson();
    }
    if (brandDetail != null) {
      data['brand_detail'] = brandDetail!.toJson();
    }
    return data;
  }
}

class Gallery {
  int? productId;
  String? imagePath;

  Gallery({this.productId, this.imagePath});

  Gallery.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['image_path'] = imagePath;
    return data;
  }
}

class ProductVendorDetails {
  int? id;
  int? vendorId;
  String? storeName;
  int? vendorType;
  int? isExculsive;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? address;
  int? totalRating;
  int? averageRating;
  String? followerCount;
  String? slug;
  String? createdAt;
  String? updatedAt;

  ProductVendorDetails(
      {this.id,
      this.vendorId,
      this.storeName,
      this.vendorType,
      this.isExculsive,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.address,
      this.totalRating,
      this.averageRating,
      this.followerCount,
      this.slug,
      this.createdAt,
      this.updatedAt});

  ProductVendorDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    storeName = json['store_name'];
    vendorType = json['vendor_type'];
    isExculsive = json['is_exculsive'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    address = json['address'];
    totalRating = json['total_rating'];
    averageRating = json['averageRating'];
    followerCount = json['follower_count'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['store_name'] = storeName;
    data['vendor_type'] = vendorType;
    data['is_exculsive'] = isExculsive;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['address'] = address;
    data['total_rating'] = totalRating;
    data['averageRating'] = averageRating;
    data['follower_count'] = followerCount;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class BrandDetail {
  int? id;
  String? brandName;
  String? image;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  BrandDetail(
      {this.id,
      this.brandName,
      this.image,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  BrandDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandName = json['brand_name'];
    image = json['image'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand_name'] = brandName;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
