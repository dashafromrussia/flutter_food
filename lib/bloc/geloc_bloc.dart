import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocation_flutter/models/models.dart';
import 'package:geolocation_flutter/geolocation_flutter..dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geolocation_service/flutter_geolocation_service.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class LocEvent extends Equatable{
  const LocEvent();
  @override
  List<Object> get props => [];
}

class GetLoc extends LocEvent{

  const GetLoc();
}



abstract class LocState extends Equatable{
  const  LocState();
  @override
  List<Object> get props => [];
}

class GetLocationBegin extends LocState{
  const GetLocationBegin();
}

class GetLocation extends LocState{
 final String city;
  const GetLocation({required this.city});
}



class ArticleErrorState extends LocState{
  const ArticleErrorState();
}

class GelocationBloc extends Bloc<LocEvent,LocState>{

  GelocationBloc() : super(const GetLocationBegin()) {
    on<LocEvent>((event,emit)async{
      if(event is GetLoc){
        Position p = await _determinePosition();
        final GeoLocationData data =
        await getGeoLocationData(latLng: GeoLocationLatLng(p.latitude, p.longitude),);
        print(data.city);
        emit(GetLocation(city:data.city!));
      }
    });
    add(const GetLoc());
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

}





