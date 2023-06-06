import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'r_and_d/feature_request_screen.dart';
import 'hidden_drawer.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        FutureProvider<Map<String, String?>>(
          create: (context) => Provider.of<AuthService>(context, listen: false)
              .fetchUserDetails(),
          initialData: const {'displayName': null, 'role': null},
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RigSat',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
        '/': (context) => const AuthenticationWrapper(),
        '/signup': (context) => const SignUpPage(),
        '/signin': (context) => SignInPage(),
        '/feature_request': (context) => const FeatureRequestScreen(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<AuthService>().currentUser;

    if (firebaseUser != null) {
      return const HiddenDrawer();
    }
    return SignInPage();
  }
}
