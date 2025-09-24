import 'dart:convert';
import './CustomerAddress .dart';

extension CustomerAddressJsonExt on CustomerAddress {
  /// تحويل CustomerAddress إلى JSON String
  String toJsonString() => jsonEncode(toJson());

  /// إنشاء CustomerAddress من JSON String
  static CustomerAddress fromJsonString(String jsonStr) {
    final Map<String, dynamic> map = jsonDecode(jsonStr);
    return CustomerAddress.fromJson(map);
  }
}
