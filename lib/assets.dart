import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

class Assets extends StatefulWidget {
  final DocumentReference<Map<String, dynamic>>? userDocRef;
  final String title;

  const Assets({super.key, required this.userDocRef, required this.title});

  @override
  _AssetsState createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  final List<Map<String, dynamic>> _assets = [
    {
      'name': 'Starlink',
      'location': 'Fort St. John',
      'repairStatus': 'Operational',
      'age': '1 years',
    },
    {
      'name': 'Booster',
      'location': 'Calgary',
      'repairStatus': 'In Repair',
      'age': '3 year',
    },
    {
      'name': 'Gas Detector',
      'location': 'Grande Prairie',
      'repairStatus': 'Operational',
      'age': '4 year',
    },
    {
      'name': 'Intercom Kit',
      'location': 'Grande Prairie',
      'repairStatus': 'Operational',
      'age': '5 years',
    },
    // Add more assets here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _assets.length,
          itemBuilder: (context, index) {
            final asset = _assets[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(asset['name'][0]),
                ),
                title: Text(asset['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location: ${asset['location']}'),
                    Text('Repair Status: ${asset['repairStatus']}'),
                    Text('Age: ${asset['age']}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () {
                    // Geolocation functionality goes here
                  },
                ),
              ),
            );
          },
        ),
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
