import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/location.dart';
import '../theme/constants.dart';

class MapScreen extends StatefulWidget {
  static String routeName = "/map";

  const MapScreen({
    Key? key, required this.locations,
  }) : super(key: key);

  final List<Location> locations;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor? markerIcon;

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    //_loadMarkerImages();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = const CameraPosition(
      target: LatLng(
          41.008587,
          28.9776001,
      ),
      zoom: 17,
    );

    return GoogleMap(
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      markers: Set.from(markers),
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (GoogleMapController controller) async {
        setState(() {
          _addMarkers(widget.locations);
        });

        Future.delayed(
            const Duration(milliseconds: 750),
                () => controller.animateCamera(
                CameraUpdate.newLatLngBounds(
                    _boundsFromLatLngList(
                        widget.locations.map((location) => LatLng(
                            location.latitude.toDouble(),
                            location.longitude.toDouble())).toList()
                    ),
                    30
                )
            )
        );
      },
    );
  }

  void _loadMarkerImages() async {
    final Uint8List customMarker = await _getBytesFromAsset(
        path: "assets/images/map-marker.png",
        width: 80
    );
    markerIcon = BitmapDescriptor.fromBytes(customMarker);
  }

  Future<Uint8List> _getBytesFromAsset({String path = "",
    int width = 0}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
        format: ui.ImageByteFormat.png))!
        .buffer.asUint8List();
  }

  void _addMarkers(List<Location> locations) {
    for (final location in locations) {
      markers.add(Marker(
          markerId: MarkerId(location.id.toString()),
          infoWindow: InfoWindow(title: location.name, onTap: () {
            _showStartMintingDialog(context, true, location);
          }),
          icon: markerIcon ?? BitmapDescriptor.defaultMarker,
          position: LatLng(
              location.latitude.toDouble(),
              location.longitude.toDouble())
      ));
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  _showStartMintingDialog(
      BuildContext context,
      bool isNearby,
      Location location,
      ) {
    final double bottomSheetPadding =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.top;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      builder: (_) {
        return Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 300,
            child: Container(
                decoration: const BoxDecoration(
                  color: kPrimaryDefaultBgColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                padding: EdgeInsets.only(top: bottomSheetPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5.0),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFC7C7C7),
                            shape: BoxShape.rectangle,
                            border: Border.all(color: const Color(0xFFC7C7C7))),
                        width: 37.0,
                        height: 5.0,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Text(location.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 24)),
                    const SizedBox(height: 12.0),

                  ],
                )),
          ),
        );
      },
    );
  }
}
