import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Provider/app_provider.dart';
import 'package:foodz_owner/Screens/EditPlateScreen.dart';
import 'package:foodz_owner/Screens/IntroScreen.dart';
import 'package:foodz_owner/Screens/LoginScreen.dart';
import 'package:foodz_owner/Screens/MainScreen.dart';
import 'package:foodz_owner/Screens/RegisterScreen.dart';
import 'package:foodz_owner/Screens/WalkthroughScreen.dart';
import 'package:foodz_owner/Screens/WelcomeScreen.dart';
import 'package:foodz_owner/Screens/PlateDetailsScreen.dart';
import 'package:foodz_owner/Screens/AddPlateScreen.dart';
import 'package:foodz_owner/Screens/TestMap.dart';
import 'package:foodz_owner/utils/consts/const.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int wlkScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  wlkScreen = prefs.getInt("showWalk");
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
          initialRoute: wlkScreen == 0
              ? FirebaseAuth.instance.currentUser == null
                  ? WelcomeScreen.tag
                  : MainScreen.tag
              : WalkthroughScreen.tag,
          routes: {
            WalkthroughScreen.tag: (context) => WalkthroughScreen(),
            WelcomeScreen.tag: (context) => WelcomeScreen(),
            RegisterScreen.tag: (context) => RegisterScreen(),
            LoginScreen.tag: (context) => LoginScreen(),
            IntroScreen.tag: (context) => IntroScreen(),
            MainScreen.tag: (context) => MainScreen(),
            FoodDetailsScreen.tag: (context) => FoodDetailsScreen(),
            AddPlateScreen.tag: (context) => AddPlateScreen(),
            EditPlateScreen.tag: (context) => EditPlateScreen(),
            TestScreen.tag: (context) => TestScreen(),
          },
          // onGenerateRoute: (RouteSettings settings) {
          //   print('build route for ${settings.name}');
          //   var routes = <String, WidgetBuilder>{
          //     FoodDetailsScreen.tag: (ctx) => FoodDetailsScreen(settings.arguments),
          //   };
          //   WidgetBuilder builder = routes[settings.name];
          //   return MaterialPageRoute(builder: (ctx) => builder(ctx));
          // },
        );
      },
    );
  }
}
