import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pingolearn_assignment/firebase_options.dart';
import 'package:pingolearn_assignment/provider/auth_provider.dart';
import 'package:pingolearn_assignment/provider/product_provider.dart';
import 'package:pingolearn_assignment/provider/remote_config_provider.dart';
import 'package:pingolearn_assignment/screens/auth/login_screen.dart';
import 'package:pingolearn_assignment/screens/auth/registration_screen.dart';
import 'package:pingolearn_assignment/screens/detailed_product_screen.dart';
import 'package:pingolearn_assignment/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RemoteConfigProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: Consumer<AuthProvider>(builder: (context, authProvider, _) {
        print(authProvider.isAuthenticated);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: authProvider.isAuthenticated
              ? const HomeScreen()
              : const RegistrationScreen(),
          theme: ThemeData(fontFamily: 'Poppins'),
        );
      }),
    );
  }
}
