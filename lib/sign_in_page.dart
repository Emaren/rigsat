import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
          child: Form(
            key: formKey,
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
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      // textInputAction: TextInputAction.next,
                      // validator: (value) {
                      //   if (value!.isEmpty || !value.contains('@')) {
                      //     return 'Please enter a valid email address.';
                      //   }
                      //   return null;
                      // },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      // textInputAction: TextInputAction
                      //     .done, // Trigger done action (hides the keyboard).
                      // onFieldSubmitted: (_) {
                      // Perform action when user hits 'enter' in password field.
                      // if (formKey.currentState!.validate()) {
                      //   context.read<AuthService>().signIn(
                      //       _emailController.text, _passwordController.text);
                      // }
                      // },
                      // validator: (value) {
                      //   if (value!.isEmpty || value.length < 6) {
                      //     return 'Password must be at least 6 characters long.';
                      //   }
                      //   return null;
                      // },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.019,
                    ),
                    ElevatedButton(
                      child: const Text("Sign In"),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthService>().signIn(
                              _emailController.text, _passwordController.text);
                        }
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
      ),
    );
  }
}
