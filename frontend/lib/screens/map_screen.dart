import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dev_go/models/custom_location.dart';
import 'package:dev_go/repositories/nft_repository.dart';
import 'package:dev_go/utils/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../components/rounded_button.dart';
import '../models/nft/user_history_response.dart';
import '../repositories/location_repository.dart';
import '../theme/constants.dart';

class MapScreen extends StatefulWidget {
  static String routeName = "/map";

  const MapScreen({
    Key? key, required this.userEmail,
  }) : super(key: key);

  final String userEmail;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor? markerIcon;

  List<Marker> markers = [];
  final ILocationRepository locationRepository = LocationRepository();
  final INftRepository nftRepository = NftRepository(DioClient().init());

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

    return LoaderOverlay(
      child: GoogleMap(
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        markers: Set.from(markers),
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) async {
          //var locations = List<Location>.empty();
          var history = List<UserHistory>.empty();
          context.loaderOverlay.show();
          try {
            //locations = await locationRepository.getLocations();
            history = await nftRepository.getUserHistory(widget.userEmail);
          } finally {
            context.loaderOverlay.hide();
          }

          setState(() {
            _addMarkers(history);
          });

          Future.delayed(
              const Duration(milliseconds: 750),
                  () => controller.animateCamera(
                  CameraUpdate.newLatLngBounds(
                      _boundsFromLatLngList(
                          history.map((location) => LatLng(
                              location.latitude.toDouble(),
                              location.longitude.toDouble())).toList()
                      ),
                      30
                  )
              )
          );
        },
      ),
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

  void _addMarkers(List<UserHistory> history) {
    for (final location in history) {
      BitmapDescriptor icon = BitmapDescriptor.defaultMarker;
      if (location.visited == 1) {
        if (location.isOG == 1) {
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
        } else {
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
        }
      }
      markers.add(Marker(
          markerId: MarkerId(location.id.toString()),
          infoWindow: InfoWindow(title: location.name, onTap: () async {
            bool isNearby = false;
            context.loaderOverlay.show();
            try {
              isNearby = await locationRepository.isUserNearbyLocation(
                  CustomLocation(
                      latitude: location.latitude.toDouble(),
                      longitude: location.longitude.toDouble()));
            } finally {
              context.loaderOverlay.hide();
            }
            _showStartMintingDialog(isNearby, location);
          }),
          icon: markerIcon ?? icon,
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
      bool isNearby,
      UserHistory location,
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
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFC7C7C7),
                            shape: BoxShape.rectangle,
                            border: Border.all(color: const Color(0xFFC7C7C7))),
                        width: 37.0,
                        height: 3.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(location.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 24)),
                    const SizedBox(height: 12.0),
                    _buildImage(location),
                    Expanded(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: isNearby ? 10.0 : 45.0),
                              child: isNearby
                                  ? _buildMintButton(widget.userEmail, location)
                                  : _buildTooFarWarning())),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  _buildImage(UserHistory location) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 100,
        child: CachedNetworkImage(
          imageUrl: location.imageUrl,
          progressIndicatorBuilder:
            (context, url, downloadProgress) =>
              Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(value: downloadProgress.progress))),
          errorWidget: (context, url, error) => Image.asset("assets/images/token_go.jpeg"),
          fit: BoxFit.cover),
      ),
    );
  }

  _buildMintButton(String email, UserHistory location) {
    bool isTapped = false;

    return TextButton(
        onPressed: () async {
          if (isTapped) {
            return;
          }

          Navigator.of(context).pop();
          context.loaderOverlay.show();
          try {
            // call minting endpoint
            final newList = await nftRepository.mint(email, location.id);
            setState(() {
              markers.clear();
              _addMarkers(newList);
            });
          } finally {
            context.loaderOverlay.hide();
          }

          // allow to click again only after 2 seconds to prevent double tap
          Future.delayed(const Duration(seconds: 2))
              .then((_) => isTapped = false);
          isTapped = true;
        },
        child: RoundedButton(
            width: 340.0,
            height: 60.0,
            text: "MINT",
            textStyle: GoogleFonts.nunito(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
            color: const Color(0xFFF12C18),
            textColor: Colors.white,
            borderRadius: 10.0));
  }

  Container _buildTooFarWarning() {
    return Container(
      alignment: Alignment.center,
      width: 300,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xFFFFE3E3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Colors.red, size: 16),
          const SizedBox(width: 10),
          Text(
            "You are too far to mint",
            style: GoogleFonts.nunito(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
