import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/app/data/models/CustomerAddress .dart';
import 'package:grocery_app/app/data/api/api_service.dart';

class AddAddressMapView extends StatefulWidget {
  final String token;

  const AddAddressMapView({Key? key, required this.token}) : super(key: key);

  @override
  _AddAddressMapViewState createState() => _AddAddressMapViewState();
}

class _AddAddressMapViewState extends State<AddAddressMapView> {
  late MapController _mapController;
  GeoPoint? _selectedPoint;
  GeoPoint? _currentMarkerPoint;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initPosition: GeoPoint(latitude: 15.3694, longitude: 44.1910), // صنعاء افتراضي
    );
    _setCurrentLocation();
  }

  Future<void> _setCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _selectedPoint = GeoPoint(latitude: position.latitude, longitude: position.longitude);
      _currentMarkerPoint = _selectedPoint;

      // تحريك الخريطة للموقع الحالي
      await _mapController.changeLocation(_selectedPoint!);

      // وضع Marker على الموقع الحالي
      await _mapController.addMarker(
        _selectedPoint!,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.location_on, color: Colors.red, size: 48),
        ),
      );
    } catch (e) {
      print("خطأ في تحديد الموقع الحالي: $e");
    }
  }

  Future<void> _saveAddress() async {
    if (_selectedPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار موقع من الخريطة")),
      );
      return;
    }

    final newAddress = CustomerAddress(
      customerAddressId: 0,
      customerAddressPublicId: "",
      streetAddress1: "موقع من الخريطة",
      streetAddress2: "",
      cityId: 0,
      cityName: "",
      regionId: 0,
      regionName: "",
      countryId: 0,
      countryName: "",
      postalCode: "",
      phone: "",
      isDefault: false,
      latitude: _selectedPoint!.latitude,
      longitude: _selectedPoint!.longitude,
    );

    try {
      final api = ApiService();
      final success = await api.addCustomerAddress(newAddress, token: widget.token);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم حفظ العنوان بنجاح ✅")),
        );
        Navigator.pop(context, newAddress);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("فشل حفظ العنوان ⚠️")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ: $e")),
      );
    }
  }

  Future<void> _onMapTap(GeoPoint point) async {
    // إزالة Marker السابق
    if (_currentMarkerPoint != null) {
      await _mapController.removeMarker(_currentMarkerPoint!);
    }

    _currentMarkerPoint = point;
    _selectedPoint = point;

    // إضافة Marker جديد
    await _mapController.addMarker(
      point,
      markerIcon: const MarkerIcon(
        icon: Icon(Icons.location_on, color: Colors.red, size: 48),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة عنوان")),
      body: Stack(
        children: [
          OSMFlutter(
            controller: _mapController,
            osmOption: const OSMOption(
              zoomOption: ZoomOption(
                initZoom: 12,
                minZoomLevel: 3,
                maxZoomLevel: 18,
                stepZoom: 1.0,
              ),
              roadConfiguration: RoadOption(
                roadColor: Colors.blue,
              ),
            ),
            onGeoPointClicked: _onMapTap,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: _saveAddress,
              icon: const Icon(Icons.save),
              label: const Text("حفظ العنوان"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
