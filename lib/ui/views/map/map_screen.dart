import 'package:ajoufinder/data/services/google_map_service.dart';
import 'package:ajoufinder/ui/shared/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget{

  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
    late GoogleMapController _mapController;
    final GoogleMapService _mapService = GoogleMapService();
    final TextEditingController _searchController = TextEditingController();
    final FocusNode _searchFocusNode = FocusNode();

    final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(37.2833808, 127.0460720),
      zoom: 18
    );

    @override
    void dispose() {
      _searchController.dispose();
      _searchFocusNode.dispose();
      super.dispose();
    }

    void _performMapSearch(String query) {
      //추후 구현
      _searchFocusNode.unfocus();
    }

      @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context); // CustomSearchBar 내부에서 테마 사용

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _mapService.setMapController(controller);
            },
            markers: _createMarkers(),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (_) { // 맵을 탭하면 검색창 포커스 해제
              _searchFocusNode.unfocus();
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10, // 상태바 높이 고려
            left: 15,
            right: 15,
            child: SearchBarWidget(
              controller: _searchController,
              hintText: '장소, 주소 검색',
              onSubmitted: _performMapSearch,
              focusNode: _searchFocusNode,
              onClear: () {
                // 검색어 클리어 시 추가 동작 (예: 검색 결과 초기화)
                print('MapScreen 검색어 클리어됨');
              },
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(37.5665, 126.9780), // 서울 중심 좌표
        infoWindow: InfoWindow(title: '마커 1', snippet: '마커 1 설명'),
        onTap: () {
          // TODO: 마커 1 클릭 시 동작 구현
          print('마커 1 클릭됨!');
        },
      ),
      Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(37.55, 126.98), // 임의 좌표
        infoWindow: InfoWindow(title: '마커 2', snippet: '마커 2 설명'),
        onTap: () {
          // TODO: 마커 2 클릭 시 동작 구현
          print('마커 2 클릭됨!');
        },
      ),
      Marker(
        markerId: MarkerId('marker_3'),
        position: LatLng(37.57, 126.96), // 임의 좌표
        infoWindow: InfoWindow(title: '마커 3', snippet: '마커 3 설명'),
        onTap: () {
          // TODO: 마커 3 클릭 시 동작 구현
          print('마커 3 클릭됨!');
        },
      ),
    };
  }
}

