class MyOrdersModel {
  int? id;
  String? orderNumber;
  int? userId;
  int? wishlistId;
  num? subTotal;
  int? shippingId;
  int? coupon;
  num? totalAmount;
  String? paymentMethod;
  String? paymentStatus;
  String? status;
  String? phone;
  String? address;
  String? address1;
  String? createdAt;
  String? updatedAt;
  int? cancelReason;
  String? description;
  List<Products>? products;

  MyOrdersModel(
      {this.id,
      this.orderNumber,
      this.userId,
      this.wishlistId,
      this.subTotal,
      this.shippingId,
      this.coupon,
      this.totalAmount,
      this.paymentMethod,
      this.paymentStatus,
      this.status,
      this.phone,
      this.address,
      this.address1,
      this.createdAt,
      this.updatedAt,
      this.cancelReason,
      this.description,
      this.products});

  MyOrdersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    userId = json['user_id'];
    wishlistId = json['wishlist_id'];
    subTotal = json['sub_total'];
    shippingId = json['shipping_id'];
    coupon = json['coupon'];
    totalAmount = json['total_amount'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    status = json['status'];
    phone = json['phone'];
    address = json['address'];
    address1 = json['address1'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cancelReason = json['cancel_reason'];
    description = json['description'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_number'] = orderNumber;
    data['user_id'] = userId;
    data['wishlist_id'] = wishlistId;
    data['sub_total'] = subTotal;
    data['shipping_id'] = shippingId;
    data['coupon'] = coupon;
    data['total_amount'] = totalAmount;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['status'] = status;
    data['phone'] = phone;
    data['address'] = address;
    data['address1'] = address1;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['cancel_reason'] = cancelReason;
    data['description'] = description;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
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
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Products(
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
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Products.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? orderId;
  int? productId;
  int? quantity;

  Pivot({this.orderId, this.productId, this.quantity});

  Pivot.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    return data;
  }
}
