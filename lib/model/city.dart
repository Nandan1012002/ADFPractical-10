import 'package:flutter/material.dart';

class City{
  int? id;

  late String cityName;
  late String cityDescription;

  City({required this.cityName,required this.cityDescription});


  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'CityName': cityName,
      'CityDescription': cityDescription,
    };
    if (id !=null){
      map['id'] = id;
    }
    return map;
  }

  City.fromMap(Map<String, dynamic> map){
    id = map['id'];
    cityName = map['CityName'];
    cityDescription = map['CityDescription'];
  }
}