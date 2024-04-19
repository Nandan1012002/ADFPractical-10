import 'package:flutter/material.dart';

import '../model/city.dart';
import '../util/database_helper.dart';
import 'design_addcity.dart';

class DesignCityListView extends StatefulWidget {
  const DesignCityListView({super.key});

  @override
  State<DesignCityListView> createState() => _DesignCityListViewState();
}

class _DesignCityListViewState extends State<DesignCityListView> {
  final dbService = DatabaseService();
  late List<City> cityList = [];

  int count = 0;

  @override
  void initState() {
    super.initState();
    _refreshCity();
  }

  Future<void> _refreshCity() async {
    final data = await dbService.getCity();
    setState(() {
      cityList = data;
      count = cityList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('City App'),
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: getListViewItemOfCity(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add City',
        onPressed: () {
          print('Floating Button Pressed');
          navigationToAddEditCity(
              City(cityName: '', cityDescription: ''), 'Add Note');
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }

  ListView getListViewItemOfCity() {
    return ListView.builder(
      itemCount: cityList.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.blueGrey,
          elevation: 1.0,
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(
                Icons.location_city_outlined,
                color: Colors.red,
              ),
            ),
            title: Text(cityList[index].cityName ?? 'Unknown'),
            subtitle: Text(cityList[index].cityDescription ?? 'unknown'),
            trailing: GestureDetector(
              child: const Icon(Icons.delete_forever, color: Colors.grey),
              onTap: () {
                _deleteCity(cityList[index].id as int);
              },
            ),
            onTap: () {
              print('ListTile Tap');
              int id1 = cityList[index].id as int;
              navigationToAddEditCity(this.cityList[index], 'Edit note');
            },
          ),
        );
      },
    );
  }

  void navigationToAddEditCity(City city, String title) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => DesignAddCity(city, title))).then((value) => _refreshCity());
  }

  void _deleteCity(int id) {
    dbService.deleteCity(id);
    _refreshCity();
  }
}
