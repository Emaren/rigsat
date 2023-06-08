import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferingsScreen extends StatelessWidget {
  final List<Recipe> Offerings = [
    Recipe('Data Hubs', 'a.png'),
    Recipe('Boosters', 'b.png'),
    Recipe('Antennas', 'c.png'),
    Recipe('Extenders', 'd.png'),
    Recipe('Links', 'e.png'),
    // Add more Offerings...
  ];

  OfferingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 192, 1, 1),
                Color.fromARGB(255, 88, 0, 0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: const Text('RigSat\'s Offerings'),
      ),
      body: ListView.builder(
        itemCount: Offerings.length,
        itemBuilder: (context, index) {
          if (index == 3) {
            return Column(
              children: [
                AppBar(
                  title: const Text('Quintel\'s Offerings'),
                  backgroundColor: const Color.fromARGB(225, 25, 0, 163),
                ),
                buildRecipeCard(index),
              ],
            );
          }
          return buildRecipeCard(index);
        },
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 75, 18, 100),
              Color.fromARGB(255, 13, 0, 152),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () {
            SimpleHiddenDrawerController.of(context).toggle();
          },
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.menu),
        ),
      ),
    );
  }

  Widget buildRecipeCard(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            // This Flexible makes the image take up 50% of the card
            Flexible(
              flex: 1,
              child: FadeInImage(
                placeholder: const AssetImage('assets/RigSat.jpg'),
                image: AssetImage('assets/${Offerings[index].imagePath}'),
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            // This Flexible makes the text take up the remaining 50% of the card
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Offerings[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      child: const Text(
                        'Contact Jeremy for more information.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () async {
                        var emailUri = Uri(
                          scheme: 'mailto',
                          path: 'jfeusi@rigsat.com',
                          query: 'subject=More%20Information%20Required',
                        );

                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri);
                        } else {
                          throw 'Could not launch $emailUri';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Recipe {
  final String name;
  final String imagePath;

  Recipe(this.name, this.imagePath);
}
