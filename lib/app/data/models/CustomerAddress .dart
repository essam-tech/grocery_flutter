class CustomerAddress {
  final int id;
  final String publicId; // 🔹 مهم للحذف
  final int customerId;
  final String streetAddress1;
  final String streetAddress2;
  final int cityId;
  final int regionId;
  final int countryId;
  final String postalCode;
  final String phone;
  final bool isDefault;
  final double latitude;
  final double longitude;

  CustomerAddress({
    required this.id,
    required this.publicId,
    required this.customerId,
    required this.streetAddress1,
    required this.streetAddress2,
    required this.cityId,
    required this.regionId,
    required this.countryId,
    required this.postalCode,
    required this.phone,
    required this.isDefault,
    required this.latitude,
    required this.longitude,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      id: json['id'] ?? 0,
      publicId: json['customerAddressPublicId']?.toString() ?? "", // 🔹 اسم الحقل من السيرفر
      customerId: json['customerId'] ?? 0,
      streetAddress1: json['streetAddress1'] ?? "",
      streetAddress2: json['streetAddress2'] ?? "",
      cityId: json['cityId'] ?? 0,
      regionId: json['regionId'] ?? 0,
      countryId: json['countryId'] ?? 0,
      postalCode: json['postalCode'] ?? "",
      phone: json['phone'] ?? "",
      isDefault: json['isDefault'] ?? false,
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customerAddressPublicId": publicId, // 🔹 اسم الحقل الصحيح عند الإرسال
      "customerId": customerId,
      "streetAddress1": streetAddress1,
      "streetAddress2": streetAddress2,
      "cityId": cityId,
      "regionId": regionId,
      "countryId": countryId,
      "postalCode": postalCode,
      "phone": phone,
      "isDefault": isDefault,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
