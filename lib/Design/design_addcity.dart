
import 'package:crud/model/city.dart';
import 'package:flutter/material.dart';
import '../Util/database_helper.dart';

class DesignAddCity extends StatefulWidget {
  final String appBarTitle;
  final City city;

  const DesignAddCity(this.city, this.appBarTitle, {super.key});

  @override
  State<DesignAddCity> createState() => _DesignAddCityState(city, appBarTitle);
}

class _DesignAddCityState extends State<DesignAddCity> {
  final dbService = DatabaseService();
  City city;

  _DesignAddCityState(this.city, this.appBarTitle);

  String appBarTitle;
  TextEditingController _controllerCityName = TextEditingController();
  TextEditingController _controllerCityDescription = TextEditingController();
  TextEditingController _controllerCityState = TextEditingController();
  TextEditingController _controllerCityCountry = TextEditingController();
  GlobalKey<FormState> _formkeyAddCityDesign = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _controllerCityDescription.text = city.cityDescription;
    _controllerCityName.text = city.cityName;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formkeyAddCityDesign,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _controllerCityName,
              decoration: InputDecoration(
                hintText: 'City Name',
              ),
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter City Name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _controllerCityDescription,
              decoration: InputDecoration(
                hintText: 'city description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter city description';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formkeyAddCityDesign.currentState?.validate() ??
                        false) {
                      _saveCity();
                    }
                  },
                  child: Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveCity() async {
    if (city.id != null) {
      String name = _controllerCityName.text.trim();
      String desc = _controllerCityDescription.text.trim();
      city.cityName = name;
      city.cityDescription = desc;

      await dbService.editCity(city as City);

      _controllerCityDescription.clear();
      _controllerCityName.clear();

      Navigator.of(context).pop();
    } else {
      String name = _controllerCityName.text.trim();
      String desc = _controllerCityDescription.text.trim();
      City city = City(cityName: name, cityDescription: desc);
      await dbService.insertCity(city as City);
      _controllerCityDescription.clear();
      _controllerCityName.clear();
      Navigator.of(context).pop();
    }
  }
}
