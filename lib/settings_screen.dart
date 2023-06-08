import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

import 'auth_service.dart';
import 'delete_account_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  String? _status;

  bool _notificationsEnabled = false;
  bool _darkMode = false;
  double _textSize = 14.0;

  void _navigateToDeleteAccountPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeleteAccountPage(
            authService: _authService,
          ),
        ),
      );

      if (result != null && result is String && mounted) {
        setState(() => _status = result);
      }
    });
  }

  Future<void> _logOut() async {
    await _authService.signOut(context);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
          ListTile(
            title: const Text('Text Size'),
            trailing: DropdownButton<double>(
              value: _textSize,
              onChanged: (double? newValue) {
                setState(() {
                  _textSize = newValue!;
                });
              },
              items: <double>[12.0, 14.0, 16.0, 18.0, 20.0]
                  .map<DropdownMenuItem<double>>(
                    (double value) => DropdownMenuItem<double>(
                      value: value,
                      child: Text(value.toString()),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Change Email'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              // Handle change email action
            },
          ),
          ListTile(
            title: const Text('Change Password'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              // Handle change password action
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            trailing: const Icon(Icons.exit_to_app),
            onTap: _logOut,
          ),
          ElevatedButton(
            onPressed: _navigateToDeleteAccountPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 200, 28, 9),
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SimpleHiddenDrawerController.of(context).toggle();
        },
        child: const Icon(Icons.menu),
      ),
    );
  }
}
