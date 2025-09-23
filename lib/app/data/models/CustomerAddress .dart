class CustomerAddress {
  final int customerAddressId;
  final String customerAddressPublicId;
  final int customerId; // ✅ الجديد
  final String? streetAddress1;
  final String? streetAddress2;
  final int cityId;
  final String? cityName;
  final int regionId;
  final String? regionName;
  final int countryId;
  final String? countryName;
  final String? postalCode;
  final String? phone;
  final bool isDefault;
  final double latitude;
  final double longitude;

  CustomerAddress({
    required this.customerAddressId,
    required this.customerAddressPublicId,
    required this.customerId, // ✅ الجديد
    this.streetAddress1,
    this.streetAddress2,
    required this.cityId,
    this.cityName,
    required this.regionId,
    this.regionName,
    required this.countryId,
    this.countryName,
    this.postalCode,
    this.phone,
    required this.isDefault,
    required this.latitude,
    required this.longitude,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      customerAddressId: json['customerAddressId'] ?? 0,
      customerAddressPublicId: json['customerAddressPublicId'] ?? '',
      customerId: json['customerId'] ?? 0, // ✅ الجديد
      streetAddress1: json['streetAddress1'],
      streetAddress2: json['streetAddress2'],
      cityId: json['cityId'] ?? 0,
      cityName: json['cityName'],
      regionId: json['regionId'] ?? 0,
      regionName: json['regionName'],
      countryId: json['countryId'] ?? 0,
      countryName: json['countryName'],
      postalCode: json['postalCode'],
      phone: json['phone'],
      isDefault: json['isDefault'] == null ? false : json['isDefault'] as bool,
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId, // ✅ لازم ترسله
      'streetAddress1': streetAddress1?.isNotEmpty == true ? streetAddress1 : "",
      'streetAddress2': streetAddress2?.isNotEmpty == true ? streetAddress2 : "",
      'cityId': cityId,
      'regionId': regionId,
      'countryId': countryId,
      'postalCode': postalCode?.isNotEmpty == true ? postalCode : "",
      'phone': phone?.isNotEmpty == true ? phone : "",
      'isDefault': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
