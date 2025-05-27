import 'package:chat2025/providers/ModelsProvider.dart';
import 'package:chat2025/providers/ChatProvider.dart';
import 'package:chat2025/screens/Guest.dart';
import 'package:chat2025/screens/Home/Home.dart';
import 'package:chat2025/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:chat2025/screens/chat/ChatScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  UserService _userService = UserService();
  @override
  Widget build(BuildContext context) {
    //le provider sera capable d'ecouter tous les changement
    //ci-dessoud de l'MaterielAPP
    //le prouver doit etre le parent et le widget superieur pour ecouter ce widget
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //ajouter le provider ModelsProvider
          //le provider ModelsProvider est un ecouteur de changement
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat2025',
        //home: AuthScreen(),
        //home: TermScreen(),
        //home: PasswordScreen(),
        //home: ChatScreen(),
        home: StreamBuilder(
          stream: _userService.user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.uid != null) {
                return ChatScreen();
              } else {
                return GuestScreen();
              }
            }
            print(snapshot.connectionState);
            return Scaffold(body: Center(child: Text('Loading...')));
          },
        ),
      ),
    );
  }
}
