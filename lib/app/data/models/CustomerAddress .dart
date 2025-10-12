class CustomerAddress {
  final int id;
  final String publicId; // 🔹 معرف عام من السيرفر
  final int customerId;
  final String streetAddress1;
  final String? streetAddress2; // 🔹 خليها قابلة للإهمال لأن ممكن تكون فاضية
  final int cityId;
  final int regionId;
  final int countryId;
  final String postalCode;
  final String phone;
  final bool isDefault;
  final double latitude;
  final double longitude;

  const CustomerAddress({
    required this.id,
    required this.publicId,
    required this.customerId,
    required this.streetAddress1,
    this.streetAddress2,
    required this.cityId,
    required this.regionId,
    required this.countryId,
    required this.postalCode,
    required this.phone,
    required this.isDefault,
    required this.latitude,
    required this.longitude,
  });

  /// 🧩 التحويل من JSON إلى كائن
  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      id: json['id'] ?? json['customerAddressId'] ?? 0, // دعم كلا الحقلين
      publicId: json['customerAddressPublicId']?.toString() ?? '',
      customerId: json['customerId'] ?? 0,
      streetAddress1: json['streetAddress1'] ?? '',
      streetAddress2: json['streetAddress2'],
      cityId: json['cityId'] ?? 0,
      regionId: json['regionId'] ?? 0,
      countryId: json['countryId'] ?? 0,
      postalCode: json['postalCode'] ?? '',
      phone: json['phone'] ?? '',
      isDefault: json['isDefault'] ?? false,
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  /// 🧩 التحويل من كائن إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'customerAddressId': id,
      'customerAddressPublicId': publicId,
      'customerId': customerId,
      'streetAddress1': streetAddress1,
      if (streetAddress2 != null && streetAddress2!.isNotEmpty)
        'streetAddress2': streetAddress2,
      'cityId': cityId,
      'regionId': regionId,
      'countryId': countryId,
      'postalCode': postalCode,
      'phone': phone,
      'isDefault': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// 🧱 نسخ الكائن مع تعديلات
  CustomerAddress copyWith({
    int? id,
    String? publicId,
    int? customerId,
    String? streetAddress1,
    String? streetAddress2,
    int? cityId,
    int? regionId,
    int? countryId,
    String? postalCode,
    String? phone,
    bool? isDefault,
    double? latitude,
    double? longitude,
  }) {
    return CustomerAddress(
      id: id ?? this.id,
      publicId: publicId ?? this.publicId,
      customerId: customerId ?? this.customerId,
      streetAddress1: streetAddress1 ?? this.streetAddress1,
      streetAddress2: streetAddress2 ?? this.streetAddress2,
      cityId: cityId ?? this.cityId,
      regionId: regionId ?? this.regionId,
      countryId: countryId ?? this.countryId,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    return 'Address(id: $id, publicId: $publicId, cityId: $cityId, phone: $phone, default: $isDefault)';
  }
}
