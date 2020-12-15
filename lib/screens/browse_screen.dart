import 'package:flutter/material.dart';
import 'package:treat_min/widgets/doctor_card.dart';
import 'package:treat_min/SearchBar.dart';

class BrowseScreen extends StatelessWidget {
  static const routeName = '/browse';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: null,
          //TODO:need to add functionality to pop the last screen in stack
          // Navigator.pop(context, false);
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/Tooth.png",
              width: 25.0,
              height: 25.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "Dentist",
              style: TextStyle(fontSize: 25.0),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
          IconButton(
            icon: Image.asset("assets/icons/Filter.png"),
            onPressed: () {
              print("Hey!");
            },
          ),
          IconButton(
            icon: Image.asset("assets/icons/Sort.png"),
            onPressed: () {
              print("Hey2!");
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          DoctorCard(),
          DoctorCard(),
          DoctorCard(),
          DoctorCard(),
          DoctorCard(),
          DoctorCard(),
          DoctorCard(),
          DoctorCard(),
          DoctorCard(),
        ],
        // scrollDirection: Axis.vertical,
      ),
    );
  }
}
