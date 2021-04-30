import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import './tabs_screen.dart';
import '../api/accounts.dart';
import '../localizations/app_localizations.dart';
import '../providers/user_data.dart';
import '../utils/dialogs.dart';
import '../widgets/input_field.dart';

class InfoScreen extends StatefulWidget {
  static const String routeName = '/info';

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final Map<String, String> _account = {};
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _dateController = TextEditingController();
  File _image;
  bool _passObscure = true;
  DateTime _date;
  int _gender = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_date == null) {
      final userData = Provider.of<UserData>(context, listen: false);
      if (userData.isLoggedIn) {
        if (userData.photo.isNotEmpty) {
          _image = File(userData.photo);
        }
        _date = userData.birth;
        _dateController.text = _date.toIso8601String().substring(0, 10);
      } else {
        _date = DateTime.now().subtract(Duration(days: 365 * 20 + 5));
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_gender < 1) {
      setState(() => _gender = 0);
      _formKey.currentState.validate();
      return;
    } else if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    _account['gender'] = _gender == 1 ? 'M' : 'F';
    _account['email'] = ModalRoute.of(context).settings.arguments;
    // if (_image != null) {
    //   final dir = await getApplicationDocumentsDirectory();
    //   final path = '${dir.path}/user.png';
    //   imageCache.clear();
    //   final photo = await _image.copy(path);
    //   _account['photo'] = photo;
    // }
    if (_image == null) {
      _account['photo'] = '';
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/account.photo';
      imageCache.clear();
      await _image.copy(path);
      _account['photo'] = path;
    }

    loading(context);
    final response = await AccountAPI.register(context, _account);
    Navigator.pop(context);

    if (response == true) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
    } else {
      alert(context, response);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(Duration(days: 365 * 80 + 20)),
      lastDate: DateTime.now().subtract(Duration(days: 365 * 12 + 3)),
      helpText: AppLocalizations.of(context).getText('select_date'),
    );
    if (picked != null) {
      _date = picked;
      setState(() {
        _dateController.text = _date.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userData = Provider.of<UserData>(context, listen: false);
    final isLoggedIn = userData.isLoggedIn;
    setAppLocalization(context);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  getText(isLoggedIn ? 'edit' : 'setup'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headline4,
                ),
              ),
              Stack(
                fit: StackFit.passthrough,
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.accentColor, width: 2),
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage('assets/images/placeholder.png')
                            : FileImage(_image),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100, left: 100),
                    child: CircleAvatar(
                      backgroundColor: theme.accentColor,
                      radius: 20,
                      child: IconButton(
                        icon: Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(
                      label: getText('password'),
                      textFormField: TextFormField(
                        decoration: InputDecoration(
                          hintText: '********',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() => _passObscure = !_passObscure);
                            },
                            child: Icon(_passObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        obscureText: _passObscure,
                        onSaved: (value) => _account['password'] = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return getText('password_empty');
                          } else if (value.length < 8) {
                            return getText('password_length');
                          } else if (int.tryParse(value) != null) {
                            return getText('password_numbers');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    InputField(
                      label: getText('name'),
                      textFormField: TextFormField(
                        decoration: InputDecoration(
                          hintText: getText('name_hint'),
                        ),
                        initialValue: isLoggedIn ? userData.name : '',
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onSaved: (value) => _account['name'] = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return getText('name_empty');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    InputField(
                      label: getText('phone'),
                      textFormField: TextFormField(
                        decoration: InputDecoration(
                          hintText: '01## ### ####',
                          counterText: '',
                        ),
                        initialValue: isLoggedIn ? userData.phone : '',
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        onSaved: (value) => _account['phone'] = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return getText('phone_empty');
                          } else if (int.tryParse(value) == null) {
                            return getText('phone_numbers_only');
                          } else if (value.length < 11) {
                            return getText('phone_11_numbers');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _pickDate();
                      },
                      child: AbsorbPointer(
                        child: InputField(
                          label: getText('birth'),
                          textFormField: TextFormField(
                            decoration: InputDecoration(hintText: 'YYYY-MM-DD'),
                            controller: _dateController,
                            onSaved: (_) =>
                                _account['birth'] = _date.toIso8601String(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return getText('birth_empty');
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(getText('gender'), style: theme.textTheme.subtitle1),
                  Spacer(),
                  Radio(
                    value: 1,
                    groupValue: _gender,
                    onChanged: (value) => setState(() => _gender = value),
                    activeColor: theme.primaryColorDark,
                  ),
                  Text(
                    getText('gender_male'),
                    style: theme.textTheme.subtitle1,
                  ),
                  Spacer(),
                  Radio(
                    value: 2,
                    groupValue: _gender,
                    onChanged: (value) => setState(() => _gender = value),
                    activeColor: theme.primaryColorDark,
                  ),
                  Text(
                    getText('gender_female'),
                    style: theme.textTheme.subtitle1,
                  ),
                ],
              ),
              _gender == 0
                  ? Text(
                      'Please select your gender!',
                      style: theme.textTheme.caption.copyWith(
                        color: theme.errorColor,
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ElevatedButton(
                  child: Text(getText(isLoggedIn ? 'save' : 'finish')),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}