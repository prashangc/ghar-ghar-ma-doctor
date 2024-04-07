class WishListModel {
  int? id;
  int? productId;
  int? userId;
  String? status;
  String? createdAt;
  String? updatedAt;
  Product? product;

  WishListModel(
      {this.id,
      this.productId,
      this.userId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.product});

  WishListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['user_id'] = userId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? productName;
  String? slug;
  String? unit;
  int? categoryId;
  String? image;
  String? imagePath;
  String? shortDesc;
  String? description;
  int? quantity;
  int? featured;
  int? userId;
  int? vendorId;
  String? discountPercent;
  int? actualRate;
  int? salePrice;
  String? averageRating;
  int? totalReviews;
  int? brand;
  List<String>? tags = [];
  int? haveStock;
  String? sku;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
      this.productName,
      this.slug,
      this.unit,
      this.categoryId,
      this.image,
      this.imagePath,
      this.shortDesc,
      this.description,
      this.quantity,
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
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    slug = json['slug'];
    unit = json['unit'];
    categoryId = json['category_id'];
    image = json['image'];
    imagePath = json['image_path'];
    shortDesc = json['shortDesc'];
    description = json['description'];
    quantity = json['quantity'];
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['quantity'] = quantity;
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
