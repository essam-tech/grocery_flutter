class ProductModel {
  final int productId;
  final String productName;
  final String? description;
  final int? storeId;
  final double? price;
  final double? productQuantity;
  final String? categoryName;
  final String? brandName;
  final String? productTypeName;
  final bool? isDigital;
  final bool? requiresShipping;
  final String? productMainImageUrl;
  final String? productMainImageAlt;
  final String? currencyCode;
  final String? currencySymbol;
  final int? productAdvancedInfoId;
  final double? discountPercent;
  final double? discountedPrice;
  final String? subtitle;
  final String? promoTitle;
  final bool? hasProductVariants;

  // ======= الحقول الجديدة =======
  int orderQuantity; // عدد المنتجات المختارة
  int? selectedVariantId; // ⚡ لتحديد الـ variant المختار

  String get availability =>
      (productQuantity != null && productQuantity! > 0) ? 'متوفرة' : 'غير متوفرة';

  List<ProductImage>? images;
  List<ProductVariant>? variants;

  ProductModel({
    required this.productId,
    required this.productName,
    this.description,
    this.storeId,
    this.price,
    this.productQuantity,
    this.categoryName,
    this.brandName,
    this.productTypeName,
    this.isDigital,
    this.requiresShipping,
    this.productMainImageUrl,
    this.productMainImageAlt,
    this.currencyCode,
    this.currencySymbol,
    this.productAdvancedInfoId,
    this.discountPercent,
    this.discountedPrice,
    this.subtitle,
    this.promoTitle,
    this.hasProductVariants,
    this.orderQuantity = 0,
    this.images,
    this.variants,
    this.selectedVariantId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      description: json['description'],
      storeId: json['storeId'],
      price: (json['price'] ?? json['productPrice'] ?? json['salePrice']) != null
          ? (json['price'] ?? json['productPrice'] ?? json['salePrice'] as num).toDouble()
          : 0.0,
      discountedPrice: (json['discountedPrice'] ?? json['variantDiscountPrice']) != null
          ? (json['discountedPrice'] ?? json['variantDiscountPrice'] as num).toDouble()
          : null,
      productQuantity: json['productQuantity'] != null
          ? (json['productQuantity'] as num).toDouble()
          : 0.0,
      categoryName: json['categoryName'],
      brandName: json['brandName'],
      productTypeName: json['productTypeName'],
      isDigital: json['isDigital'],
      requiresShipping: json['requiresShipping'],
      productMainImageUrl: json['productMainImageUrl'],
      productMainImageAlt: json['productMainImageAlt'],
      currencyCode: json['currencyCode'],
      currencySymbol: json['currencySymbol'],
      productAdvancedInfoId: json['productAdvancedInfoId'],
      discountPercent: json['discountPercent'] != null
          ? (json['discountPercent'] as num).toDouble()
          : 0.0,
      subtitle: json['subtitle'],
      promoTitle: json['promoTitle'],
      hasProductVariants: json['hasProductVariants'],
      orderQuantity: 0,
      images: json['images'] != null
          ? List<ProductImage>.from(
              (json['images'] as List).map((x) => ProductImage.fromJson(x)))
          : [],
      variants: json['variantDetail'] != null
          ? List<ProductVariant>.from(
              (json['variantDetail'] as List)
                  .map((x) => ProductVariant.fromJson(x)))
          : [],
      selectedVariantId: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'description': description ?? '',
      'storeId': storeId,
      'price': price,
      'productQuantity': productQuantity,
      'categoryName': categoryName,
      'brandName': brandName,
      'productTypeName': productTypeName,
      'isDigital': isDigital,
      'requiresShipping': requiresShipping,
      'productMainImageUrl': productMainImageUrl,
      'productMainImageAlt': productMainImageAlt,
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'productAdvancedInfoId': productAdvancedInfoId,
      'discountPercent': discountPercent,
      'discountedPrice': discountedPrice,
      'subtitle': subtitle,
      'promoTitle': promoTitle,
      'hasProductVariants': hasProductVariants,
      'orderQuantity': orderQuantity,
      'selectedVariantId': selectedVariantId ?? 0,
      'images': images?.map((e) => e.toJson()).toList(),
      'variants': variants?.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductImage {
  final int imageId;
  final String imageUrl;
  final String? videoUrl;
  final bool? isMain;
  final String? altText;

  ProductImage({
    required this.imageId,
    required this.imageUrl,
    this.videoUrl,
    this.isMain,
    this.altText,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        imageId: json['imageId'],
        imageUrl: json['imageUrl'],
        videoUrl: json['videoUrl'],
        isMain: json['isMain'],
        altText: json['altText'],
      );

  Map<String, dynamic> toJson() => {
        'imageId': imageId,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'isMain': isMain,
        'altText': altText,
      };
}

class ProductVariant {
  final int productVariantId;
  final int productId;
  final String productName;
  final String? sku;
  final double? variantSalePrice;
  final double? variantDiscountPrice;
  final double? variantQuantity;
  final bool? isDefault;

  ProductVariant({
    required this.productVariantId,
    required this.productId,
    required this.productName,
    this.sku,
    this.variantSalePrice,
    this.variantDiscountPrice,
    this.variantQuantity,
    this.isDefault,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        productVariantId: json['productVariantId'],
        productId: json['productId'],
        productName: json['productName'],
        sku: json['sku'],
        variantSalePrice: json['variantSalePrice'] != null
            ? (json['variantSalePrice'] as num).toDouble()
            : null,
        variantDiscountPrice: json['variantDiscountPrice'] != null
            ? (json['variantDiscountPrice'] as num).toDouble()
            : null,
        variantQuantity: json['variantQuantity'] != null
            ? (json['variantQuantity'] as num).toDouble()
            : null,
        isDefault: json['isDefault'],
      );

  Map<String, dynamic> toJson() => {
        'productVariantId': productVariantId,
        'productId': productId,
        'productName': productName,
        'sku': sku,
        'variantSalePrice': variantSalePrice,
        'variantDiscountPrice': variantDiscountPrice,
        'variantQuantity': variantQuantity,
        'isDefault': isDefault,
      };
}
