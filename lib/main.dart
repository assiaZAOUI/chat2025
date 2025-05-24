import 'package:chat2025/screens/Guest.dart';
import 'package:chat2025/screens/dashboard/Home.dart';
import 'package:chat2025/screens/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  UserService _userService = UserService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat2025',
      //home: AuthScreen(),
      //home: TermScreen(),
      //home: PasswordScreen(),
      home: StreamBuilder(
        stream: _userService.user,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            if (snapshot.data?.uid != null) {
              return HomeScreen();
            } else {
              return GuestScreen();
            }
          }
          print(snapshot.connectionState);
          return Scaffold(body: Center(child: Text('Loading...')));
        },
      ),
    );
  }
}
