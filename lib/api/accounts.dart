import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../localizations/app_localizations.dart';
import '../providers/user_data.dart';
import '../utils/dialogs.dart';

class AccountAPI {
  static final String _baseURL = 'https://www.treat-min.com/api/accounts';
  static final Map<String, String> _headers = {
    "content-type": "application/json",
    "accept": "application/json"
  };

  static String token(BuildContext context) {
    return Provider.of<UserData>(context, listen: false).token;
  }

  static Future<bool> registerEmail(BuildContext context, String email) async {
    loading(context);
    final response = await http.post(
      '$_baseURL/register-email/',
      body: {"email": email},
    );
    Navigator.pop(context);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      if (jsonBody.containsKey('email')) {
        alert(context, getText('email_valid'));
      } else if (jsonBody.containsKey('details')) {
        alert(context, jsonBody['details']);
      }
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }

  static Future<bool> registerCode(
      BuildContext context, String email, int code) async {
    loading(context);
    final response = await http.patch(
      '$_baseURL/register-code/',
      headers: _headers,
      body: json.encode({"email": email, "code": code}),
    );
    Navigator.pop(context);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      alert(context, 'The code you entered is not correct!');
    } else if (response.statusCode == 404) {
      alert(context, 'This email address was not registered before!');
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }

  static Future<bool> register(
      BuildContext context, Map<String, String> userData) async {
    loading(context);
    final response = await http.post(
      '$_baseURL/register/',
      body: userData,
    );
    Navigator.pop(context);

    if (response.statusCode == 201) {
      userData.remove('password');
      userData['token'] = json.decode(response.body)['token'];
      await Provider.of<UserData>(context, listen: false).saveData(userData);
      return true;
    } else if (response.statusCode == 400) {
      alert(context, json.decode(response.body)['details']);
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }

  static Future<bool> login(
      BuildContext context, Map<String, String> userData) async {
    loading(context);
    final response = await http.post(
      '$_baseURL/login/',
      body: userData,
    );
    Navigator.pop(context);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final int id = jsonResponse['user'].remove('id');
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(
          Uri.parse('https://www.treat-min.com/media/photos/users/$id.png'));
      final photo = await request.close();

      final userData = Map<String, String>.from(jsonResponse['user']);
      userData['token'] = jsonResponse['token'];
      if (photo.statusCode == 404) {
        userData['photo'] = '';
      } else {
        loading(context);
        final bytes = await consolidateHttpClientResponseBytes(photo);
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/user.png';
        final file = File(path);
        await file.writeAsBytes(bytes);
        userData['photo'] = path;
        Navigator.pop(context);
      }
      await Provider.of<UserData>(context, listen: false).saveData(userData);
      return true;
    } else if (response.statusCode == 400) {
      alert(context, 'Email or password are incorrect!');
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }

  static Future<bool> logout(BuildContext context) async {
    loading(context);
    final response = await http.post(
      '$_baseURL/logout/',
      headers: {"Authorization": "Token ${token(context)}"},
    );
    Navigator.pop(context);

    if (response.statusCode == 204) {
      await Provider.of<UserData>(context, listen: false).logOut();
      return true;
    } else if (response.statusCode == 401) {
      alert(context, 'Invalid Token!');
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }

  static Future<bool> passwordEmail(BuildContext context, String email) async {
    loading(context);
    final response = await http.post(
      '$_baseURL/password-email/',
      body: {"email": email},
    );
    Navigator.pop(context);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      alert(context, getText('email_valid'));
    } else if (response.statusCode == 404) {
      alert(context, 'This email address was not registered before!');
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }

  static Future<bool> passwordCode(
      BuildContext context, String email, int code) async {
    loading(context);
    final response = await http.patch(
      '$_baseURL/password-code/',
      headers: _headers,
      body: json.encode({"email": email, "code": code}),
    );
    Navigator.pop(context);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      alert(context, 'The code you entered is not correct!');
    } else if (response.statusCode == 404) {
      alert(context, 'This user didn\'t request to reset his password!');
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }

  static Future<bool> passwordReset(
      BuildContext context, String email, String password) async {
    loading(context);
    final response = await http.patch(
      '$_baseURL/password-reset/',
      body: {"email": email, "password": password},
    );
    Navigator.pop(context);

    if (response.statusCode == 202) {
      return true;
    } else if (response.statusCode == 400) {
      alert(
        context,
        'Please verify your account with the code sent to your email',
      );
    } else if (response.statusCode == 404) {
      alert(context, json.decode(response.body)['details']);
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }

  static Future<bool> changePassword(
      BuildContext context, String old, String password) async {
    loading(context);
    final response = await http.patch(
      '$_baseURL/change-password/',
      body: {"old": old, "password": password},
      headers: {"Authorization": "Token ${token(context)}"},
    );
    Navigator.pop(context);

    if (response.statusCode == 202) {
      return true;
    } else if (response.statusCode == 400) {
      alert(context, 'Your current password is incorrect!');
    } else if (response.statusCode == 401) {
      alert(context, 'Invalid Token!');
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }

  static Future<bool> changePhoto(BuildContext context, File photo) async {
    loading(context);
    final file = await http.MultipartFile.fromPath('photo', photo.path);
    final request =
        http.MultipartRequest('PATCH', Uri.parse('$_baseURL/change-photo/'));
    request.headers["Authorization"] = "Token ${token(context)}";
    request.files.add(file);
    final response = await request.send();
    Navigator.pop(context);

    if (response.statusCode == 202) {
      return true;
    } else if (response.statusCode == 401) {
      alert(context, 'Invalid Token!');
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }

  static Future<bool> editAccount(
      BuildContext context, Map<String, String> userData) async {
    loading(context);
    final response = await http.patch(
      '$_baseURL/edit-account/',
      body: userData,
      headers: {"Authorization": "Token ${token(context)}"},
    );
    Navigator.pop(context);

    if (response.statusCode == 202) {
      final account = Provider.of<UserData>(context, listen: false);
      userData.remove('password');
      userData['token'] = token(context);
      userData['email'] = account.email;
      await account.saveData(userData);
      return true;
    } else if (response.statusCode == 400) {
      alert(context, 'Email or password are incorrect!');
    } else if (response.statusCode == 401) {
      alert(context, 'Invalid Token!');
    } else {
      alert(context, 'Something went wrong!');
    }
    return false;
  }
}
