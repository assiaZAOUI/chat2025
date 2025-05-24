import 'package:chat2025/models/UserModel.dart';
import 'package:chat2025/screens/guest/Auth.dart';
import 'package:chat2025/screens/guest/Password.dart';
import 'package:chat2025/screens/guest/Term.dart';
import 'package:chat2025/screens/services/CommonService.dart';
import 'package:chat2025/screens/services/UserService.dart';
import 'package:flutter/material.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  UserService _userService = UserService();

  CommonService _commonService = CommonService();
  final List<Widget> _widgets = [];
  int _indexSelected = 0;

  String _email = '';

  @override
  void initState() {
    super.initState();

    AuthScreen authScreen = AuthScreen(
      onChangedStep: (index, value) async {
        StateRegistration stateRegistration = await _userService.mailinglist(
          value,
        );
        setState(() {
          _indexSelected = index;
          _email = value;
          if (stateRegistration == StateRegistration.COMPLETE) {
            _indexSelected = _widgets.length - 1; // Skip to PasswordScreen
          }
        });
      },
    );

    _commonService.terms.then(
      (terms) => setState(
        () => _widgets.addAll([
          authScreen,
          TermScreen(
            terms: terms,
            onChangedStep: (index) => setState(() => _indexSelected = index),
          ),
          PasswordScreen(
            onChangedStep:
                (index, value) => setState(() {
                  if (index != null) {
                    _indexSelected = index;
                  }
                  if (value != null) {
                    _userService
                        .auth(UserModel(email: _email, password: value))
                        .then((value) => print(value.toJson()));
                  }
                }),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          _widgets.length == 0
              ? SafeArea(
                child: Scaffold(body: Center(child: Text('loading...'))),
              )
              : _widgets.elementAt(_indexSelected),
    );
  }
}
