import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/enumerations.dart';
import '../main.dart';

class AppData with ChangeNotifier {
  String language;
  bool notifications;
  bool isFirstRun;

  List clinics = [];
  List rooms = [];
  List services = [];

  Future setLanguage(BuildContext context, String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', languageCode);
    language = languageCode;
    MyApp.setLocale(context, Locale(languageCode));
  }

  Future setNotifications(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', val);
    notifications = val;
    notifyListeners();
  }

  Future load(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('isFirstRun')) {
      prefs.setBool('isFirstRun', false);
      isFirstRun = true;
      setNotifications(true);
      setLanguage(context, Localizations.localeOf(context).languageCode);
    } else {
      isFirstRun = false;
      language = prefs.getString('language');
      notifications = prefs.getBool('notifications');
    }
  }

  void setEntities(Entity entity, List list) {
    switch (entity) {
      case Entity.clinic:
        clinics = list;
        break;
      case Entity.room:
        rooms = list;
        break;
      case Entity.service:
        services = list;
        break;
    }
    // notifyListeners();
  }

  List getEntities(Entity entity) {
    switch (entity) {
      case Entity.clinic:
        return clinics;
      case Entity.room:
        return rooms;
      case Entity.service:
        return services;
      default:
        return [];
    }
  }
}
