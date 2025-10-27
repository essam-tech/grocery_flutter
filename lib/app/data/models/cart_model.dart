// models/cart_model.dart
class CartHeader {
  int cartHeaderId;
  double cartTotal;
  int customerId;
  int warehouseId;
  String sessionId;
  String couponCode;
  double discountAmount;
  double discountCoupon;
  double shippingFee;
  double taxAmountTotal;
  double amount;
  DateTime createdAt;
  Currency currency;
  List<CartDetail> details;

  CartHeader({
    required this.cartHeaderId,
    required this.cartTotal,
    required this.customerId,
    required this.warehouseId,
    required this.sessionId,
    required this.couponCode,
    required this.discountAmount,
    required this.discountCoupon,
    required this.shippingFee,
    required this.taxAmountTotal,
    required this.amount,
    required this.createdAt,
    required this.currency,
    required this.details,
  });

  factory CartHeader.fromJson(Map<String, dynamic> json) {
    return CartHeader(
      cartHeaderId: json['cartHeaderId'] ?? 0,
      cartTotal: (json['cartTotal'] ?? 0).toDouble(),
      customerId: json['customerId'] ?? 0,
      warehouseId: json['warehouseId'] ?? 0,
      sessionId: json['sessionId'] ?? '',
      couponCode: json['couponCode'] ?? '',
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      discountCoupon: (json['discountCoupon'] ?? 0).toDouble(),
      shippingFee: (json['shippingFee'] ?? 0).toDouble(),
      taxAmountTotal: (json['taxAmountTotal'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
      currency: Currency.fromJson(json['currency'] ?? {}),
      details: (json['details'] as List<dynamic>? ?? [])
          .map((e) => CartDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartHeaderId': cartHeaderId,
      'cartTotal': cartTotal,
      'customerId': customerId,
      'warehouseId': warehouseId,
      'sessionId': sessionId,
      'couponCode': couponCode,
      'discountAmount': discountAmount,
      'discountCoupon': discountCoupon,
      'shippingFee': shippingFee,
      'taxAmountTotal': taxAmountTotal,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'currency': currency.toJson(),
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}

class CartDetail {
  int cartDetailId;
  int productId;
  String productName;
  String description;
  String imageUrl;
  int productVariantId;
  int quantity;
  double unitPrice;
  double taxAmount;
  double discountAmount;
  double total;
  List<CartOption> options;
  String note;

  CartDetail({
    required this.cartDetailId,
    required this.productId,
    required this.productName,
    required this.description,
    required this.imageUrl,
    required this.productVariantId,
    required this.quantity,
    required this.unitPrice,
    required this.taxAmount,
    required this.discountAmount,
    required this.total,
    required this.options,
    required this.note,
  });

  factory CartDetail.fromJson(Map<String, dynamic> json) {
    return CartDetail(
      cartDetailId: json['cartDetailId'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      productVariantId: json['productVariantId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => CartOption.fromJson(e))
          .toList(),
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartDetailId': cartDetailId,
      'productId': productId,
      'productName': productName,
      'description': description,
      'imageUrl': imageUrl,
      'productVariantId': productVariantId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'total': total,
      'options': options.map((e) => e.toJson()).toList(),
      'note': note,
    };
  }
}

class CartOption {
  String name;
  CartOptionValue value;
  String type;

  CartOption({required this.name, required this.value, required this.type});

  factory CartOption.fromJson(Map<String, dynamic> json) {
    return CartOption(
      name: json['name'] ?? '',
      value: CartOptionValue.fromJson(json['value'] ?? {}),
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value.toJson(),
      'type': type,
    };
  }
}

class CartOptionValue {
  String code;
  String label;

  CartOptionValue({required this.code, required this.label});

  factory CartOptionValue.fromJson(Map<String, dynamic> json) {
    return CartOptionValue(
      code: json['code'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'label': label,
    };
  }
}

class Currency {
  int currencyId;
  String code;
  String currencyName;
  String symbol;
  String icon;

  Currency({
    required this.currencyId,
    required this.code,
    required this.currencyName,
    required this.symbol,
    required this.icon,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyId: json['currencyId'] ?? 0,
      code: json['code'] ?? '',
      currencyName: json['currencyName'] ?? '',
      symbol: json['symbol'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencyId': currencyId,
      'code': code,
      'currencyName': currencyName,
      'symbol': symbol,
      'icon': icon,
    };
  }
}
