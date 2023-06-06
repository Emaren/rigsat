import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class SignInPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
          child: AutofillGroup(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  Image.asset(
                    'assets/RigSat.jpg',
                    width: screenSize.width * 0.9,
                    height: screenSize.height * 0.11,
                    fit: BoxFit.contain,
                  ),
                  TextField(
                    controller: _emailController,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    autofillHints: const [AutofillHints.password],
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.019,
                  ),
                  ElevatedButton(
                    child: const Text("Sign In"),
                    onPressed: () {
                      context.read<AuthService>().signIn(
                          _emailController.text, _passwordController.text);
                    },
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    height: 27,
                    child: TextButton(
                      onPressed: () {
                        // TODO: implement forgot password
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 34,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 16),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'New Employee?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 1, 1, 1),
                              fontSize: 11.0,
                            ),
                          ),
                          SizedBox(height: 0),
                          Text(
                            'Register Now',
                            style: TextStyle(
                              color: Color.fromARGB(255, 1, 8, 203),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
