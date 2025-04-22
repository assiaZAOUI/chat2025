import 'package:chat2025/screens/guest/Auth.dart';
import 'package:chat2025/screens/guest/Password.dart';
import 'package:chat2025/screens/guest/Term.dart';
import 'package:flutter/material.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  final List<Widget> _widgets = [];
  int _indexSelected = 0;

  @override
  void initState() {
    super.initState();
    _widgets.addAll([
      AuthScreen(
        onChangedStep: (index) => setState(() => _indexSelected = index),
      ),
      TermScreen(
        onChangedStep: (index) => setState(() => _indexSelected = index),
      ),
      PasswordScreen(
        onChangedStep: (index) => setState(() => _indexSelected = index),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _widgets.elementAt(_indexSelected));
  }
}
