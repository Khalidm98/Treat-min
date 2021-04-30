import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// import '../localizations/app_localizations.dart';
import '../providers/app_data.dart';
import '../utils/enumerations.dart';

class EntityAPI {
  static final String _baseURL = 'https://www.treat-min.com/api';

  // static final Map<String, String> _headers = {
  //   "content-type": "application/json",
  //   "accept": "application/json"
  // };

  static Future getEntities(BuildContext context, Entity entity) async {
    final response = await http.get('$_baseURL/${entityToString(entity)}/');
    if (response.statusCode == 200) {
      // print(utf8.decode(response.bodyBytes));
      Provider.of<AppData>(context, listen: false).setEntities(
        entity,
        json.decode(utf8.decode(response.bodyBytes))[entityToString(entity)],
      );
      return true;
    }
    return 'Something went wrong!';
  }
}