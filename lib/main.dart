import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Provider/app_provider.dart';
import 'package:foodz_owner/Screens/IntroScreen.dart';
import 'package:foodz_owner/Screens/LoginScreen.dart';
import 'package:foodz_owner/Screens/MainScreen.dart';
import 'package:foodz_owner/Screens/RegisterScreen.dart';
import 'package:foodz_owner/Screens/WalkthroughScreen.dart';
import 'package:foodz_owner/Screens/WelcomeScreen.dart';
import 'package:foodz_owner/utils/consts/const.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return MaterialApp(
          //theme: ThemeData.dark(),
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          darkTheme: Constants.darkTheme,
          initialRoute: WalkthroughScreen.tag,
          routes: {
            WalkthroughScreen.tag: (context) => WalkthroughScreen(),
            WelcomeScreen.tag: (context) => WelcomeScreen(),
            RegisterScreen.tag: (context) => RegisterScreen(),
            LoginScreen.tag: (context) => LoginScreen(),
            IntroScreen.tag: (context) => IntroScreen(),
            MainScreen.tag: (context) => MainScreen(),
          },
        );
      },
    );
  }
}
