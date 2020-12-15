import 'package:flutter/material.dart';
import 'package:treat_min/widgets/doctor_card.dart';

class DataSearch extends SearchDelegate<String> {
  final hospitals = [
    'dar elfouad',
    'elnile',
    'elyasmeen',
    'aman',
    'elseoudi elalmani',
    'elkahraba'
  ];
  final recentHospitals = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    //TODO:return this Doctor info here
    return DoctorCard();
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestedHospitals = query.isEmpty
        ? recentHospitals
        : hospitals.where((p) => p.startsWith(query.toLowerCase())).toList();
    return ListView.builder(
        itemCount: suggestedHospitals.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: RichText(
              text: TextSpan(
                  text: suggestedHospitals[index].substring(0, query.length),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(
                        text: suggestedHospitals[index].substring(query.length),
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                  ]),
            ),
            onTap: () {
              showResults(context);
            },
          );
        });

    throw UnimplementedError();
  }
}
