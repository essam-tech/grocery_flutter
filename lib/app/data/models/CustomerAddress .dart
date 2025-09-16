  class CustomerAddress {
    final int customerAddressId;
    final String customerAddressPublicId;
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
        // لاحظ: عند الـ PUT/POST الـ API يحتاج حقول معينة فقط؛ عدل حسب الـ Swagger إذا لازم
        'streetAddress1': streetAddress1,
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
  }
