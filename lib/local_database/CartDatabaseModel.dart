const String tableName = 'MyCart'; // name of the table in the database

class MyCartDatabaseColumns {
  static final List<String> values = [
    /// Add all fields
    id, userID, productID, vendorID, productName, productPrice,
    sellingPriceAfterDiscount, productQuantity, totalSellingPriceAfterDiscount,
    productTotalAmount,
    discount,
    productUnit,
    productImage,
    stock,
  ];

  static const String id = '_id';
  static const String productName = 'name';
  static const String userID = 'userID';
  static const String productID = 'productID';
  static const String vendorID = 'vendorID';
  static const String productPrice = 'price';
  static const String sellingPriceAfterDiscount = 'sellingPriceAfterDiscount';
  static const String totalSellingPriceAfterDiscount =
      'totalSellingPriceAfterDiscount';
  static const String productQuantity = 'quantity';
  static const String productTotalAmount = 'productTotalAmount';
  static const String discount = 'discount';
  static const String productUnit = 'unit';
  static const String productImage = 'image';
  static const String stock = 'stock';
} // name of the columns in the table in the database

class MyCartDatabaseModel {
  final int? id;
  final int? userID;
  final int? productID;
  final int? vendorID;
  final String? productName;
  final String? productPrice;
  final String? sellingPriceAfterDiscount;
  final String? totalSellingPriceAfterDiscount;
  final String? productQuantity;
  final String? productTotalAmount;
  final String? discount;
  final String? productUnit;
  final String? productImage;
  final String? stock;

  const MyCartDatabaseModel({
    this.id,
    this.userID,
    this.productID,
    this.vendorID,
    this.productName,
    this.productPrice,
    this.sellingPriceAfterDiscount,
    this.totalSellingPriceAfterDiscount,
    this.productQuantity,
    this.productTotalAmount,
    this.discount,
    this.productUnit,
    this.productImage,
    this.stock,
  });

  MyCartDatabaseModel copy({
    final int? id,
    final int? userID,
    final int? productID,
    final int? vendorID,
    final String? productName,
    final String? productPrice,
    final String? sellingPriceAfterDiscount,
    final String? totalSellingPriceAfterDiscount,
    final String? productQuantity,
    final String? productTotalAmount,
    final String? discount,
    final String? productUnit,
    final String? productImage,
    final String? stock,
  }) =>
      MyCartDatabaseModel(
        id: id ?? this.id,
        userID: userID ?? this.userID,
        productID: productID ?? this.productID,
        vendorID: vendorID ?? this.vendorID,
        productName: productName ?? this.productName,
        productPrice: productPrice ?? this.productPrice,
        sellingPriceAfterDiscount:
            sellingPriceAfterDiscount ?? this.sellingPriceAfterDiscount,
        totalSellingPriceAfterDiscount: totalSellingPriceAfterDiscount ??
            this.totalSellingPriceAfterDiscount,
        productQuantity: productQuantity ?? this.productQuantity,
        productTotalAmount: productTotalAmount ?? this.productTotalAmount,
        discount: discount ?? this.discount,
        productUnit: productUnit ?? this.productUnit,
        productImage: productImage ?? this.productImage,
        stock: stock ?? this.stock,
      );

  static MyCartDatabaseModel fromJson(Map<String, Object?> json) =>
      MyCartDatabaseModel(
        id: json[MyCartDatabaseColumns.id] as int?,
        userID: json[MyCartDatabaseColumns.userID] as int?,
        productID: json[MyCartDatabaseColumns.productID] as int?,
        vendorID: json[MyCartDatabaseColumns.vendorID] as int?,
        productName: json[MyCartDatabaseColumns.productName] as String,
        productPrice: json[MyCartDatabaseColumns.productPrice] as String,
        sellingPriceAfterDiscount:
            json[MyCartDatabaseColumns.sellingPriceAfterDiscount] as String,
        totalSellingPriceAfterDiscount:
            json[MyCartDatabaseColumns.totalSellingPriceAfterDiscount]
                as String,
        productQuantity: json[MyCartDatabaseColumns.productQuantity] as String,
        productTotalAmount:
            json[MyCartDatabaseColumns.productTotalAmount] as String,
        discount: json[MyCartDatabaseColumns.discount] as String,
        productUnit: json[MyCartDatabaseColumns.productUnit] as String,
        productImage: json[MyCartDatabaseColumns.productImage] as String,
        stock: json[MyCartDatabaseColumns.stock] as String,
      );
  Map<String, Object?> toJson() => {
        MyCartDatabaseColumns.id: id,
        MyCartDatabaseColumns.userID: userID,
        MyCartDatabaseColumns.productID: productID,
        MyCartDatabaseColumns.vendorID: vendorID,
        MyCartDatabaseColumns.productName: productName,
        MyCartDatabaseColumns.productPrice: productPrice,
        MyCartDatabaseColumns.sellingPriceAfterDiscount:
            sellingPriceAfterDiscount,
        MyCartDatabaseColumns.totalSellingPriceAfterDiscount:
            totalSellingPriceAfterDiscount,
        MyCartDatabaseColumns.productQuantity: productQuantity,
        MyCartDatabaseColumns.productTotalAmount: productTotalAmount,
        MyCartDatabaseColumns.discount: discount,
        MyCartDatabaseColumns.productUnit: productUnit,
        MyCartDatabaseColumns.productImage: productImage,
        MyCartDatabaseColumns.stock: stock,
      };
}
