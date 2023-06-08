import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'firebase_options.dart';
import 'r_and_d/feature_request_screen.dart';
import 'hidden_drawer.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

void main() async {
  print('Starting the application...');
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase...');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully!');
  } catch (error) {
    print('Failed to initialize Firebase: $error');
  }

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
    print('Building MainApp...');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RigSat',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
        '/': (context) => const AuthenticationWrapper(),
        '/signup': (context) => const SignUpPage(),
        '/signin': (context) => const SignInPage(),
        '/feature_request': (context) => const FeatureRequestScreen(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building AuthenticationWrapper...');
    final firebaseUser = context.watch<AuthService>().currentUser;

    if (firebaseUser != null) {
      print('User is authenticated: ${firebaseUser.uid}');
      return const HiddenDrawer();
    }
    print('User is not authenticated. Showing SignInPage...');
    return const SignInPage();
  }
}
