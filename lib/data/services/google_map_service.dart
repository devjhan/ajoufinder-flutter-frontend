import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapService {
  late GoogleMapController _mapController;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> moveToPosition(
      double latitude, double longitude, double zoom) async {
    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: zoom),
      ),
    );
  }

  Future<void> searchAndMove(String query) async {
    // TODO: 검색어를 좌표로 변환하는 기능 추가 (Geocoding API 호출 등)
    // 검색 기능 구현
  }

  void addMarker(Marker marker) {
    // TODO: 마커 추가 기능 구현
  }

  void removeMarker(MarkerId markerId) {
    // TODO: 마커 삭제 기능 구현
  }

  void clearMarkers() {
    // TODO: 모든 마커 삭제 기능 구현
  }
}

