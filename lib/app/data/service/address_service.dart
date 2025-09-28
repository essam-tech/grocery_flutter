import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/CustomerAddress .dart';

class AddressService {
  final String baseUrl = "https://YOUR_API_URL/api";

  Future<List<CustomerAddress>> fetchAddresses(String token, int customerId) async {
    if (token.isEmpty || customerId == 0) {
      print("! fetchAddresses skipped: invalid customerId or token.");
      return [];
    }

    final url = Uri.parse("$baseUrl/customers/$customerId/addresses");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<CustomerAddress> addresses = (data as List)
          .map((json) => CustomerAddress.fromJson(json))
          .toList();
      return addresses;
    } else {
      throw Exception("Failed to load addresses: ${response.body}");
    }
  }

  Future<CustomerAddress> addAddress(String token, int customerId, CustomerAddress address) async {
    final url = Uri.parse("$baseUrl/customers/$customerId/addresses");
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(address.toJson()),
    );

    if (response.statusCode == 201) {
      return CustomerAddress.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add address: ${response.body}");
    }
  }
}
