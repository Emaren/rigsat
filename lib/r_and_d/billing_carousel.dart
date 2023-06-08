import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class BillingCarousel extends StatefulWidget {
  const BillingCarousel({super.key});

  @override
  _BillingCarouselState createState() => _BillingCarouselState();
}

class _BillingCarouselState extends State<BillingCarousel> {
  final List<DateTime> _months =
      List<DateTime>.generate(12, (i) => DateTime(DateTime.now().year, i + 1));
  final Map<String, TextEditingController> _controllers = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Future<DocumentSnapshot>? document;

  // Adding a PageController to make the carousel initially show the current month
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Fetch user when the widget initializes
    user = _auth.currentUser;
    document = _firestore.collection('billing').doc('sharedData').get();

    // Initialize the PageController to show the current month initially
    _pageController = PageController(
      initialPage: DateTime.now().month - 1,
    );
  }

  @override
  void dispose() {
    // Dispose the TextEditingControllers and PageController when the widget is disposed
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildBillingCardCarousel() {
    return SizedBox(
      height: 600,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          return _buildBillingCard(_months[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _buildBillingCardCarousel()),
    );
  }

  void _updateDescription(String dateFormatted, String value, int descIndex) {
    _firestore.collection('billing').doc('sharedData').set({
      '$dateFormatted.$descIndex.description': value,
    }, SetOptions(merge: true));
  }

  void _updateHours(String dateFormatted, String hours, int descIndex) {
    if (double.tryParse(hours) != null) {
      _firestore.collection('billing').doc('sharedData').set({
        '$dateFormatted.$descIndex.hours': hours,
      }, SetOptions(merge: true));
    }
  }

  Widget _buildBillingCard(DateTime month) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    return FutureBuilder<DocumentSnapshot>(
      future: document,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitSpinningCircle(
              color: Color.fromARGB(255, 8, 19, 174));
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic>? data =
                snapshot.data?.data() as Map<String, dynamic>?;
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMMM').format(month),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: daysInMonth,
                          itemBuilder: (BuildContext context, int index) {
                            DateTime day =
                                DateTime(month.year, month.month, index + 1);
                            String dateFormatted =
                                DateFormat('yyyy-MM-dd').format(day);

                            // Highlight the current date in blue color
                            DateTime now = DateTime.now();
                            bool isCurrentDate =
                                DateTime(now.year, now.month, now.day) ==
                                    DateTime(day.year, day.month, day.day);

                            // Get the values from Firestore
                            dynamic dailyDataRaw = data?[dateFormatted];
                            List<dynamic> dailyDataList;

                            if (dailyDataRaw is List<dynamic>) {
                              dailyDataList = dailyDataRaw;
                              // If dailyDataList has fewer than 4 elements, add empty maps
                              while (dailyDataList.length < 2) {
                                dailyDataList
                                    .add({'description': '', 'hours': ''});
                              }
                            } else {
                              // Initialize an empty list when there's no data
                              dailyDataList = List.generate(1,
                                  (index) => {'description': '', 'hours': ''});
                            }

                            return Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: isCurrentDate
                                          ? const Color.fromARGB(255, 9, 9, 183)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: Column(
                                    children: List.generate(1, (descIndex) {
                                      Map<String, dynamic> dailyData =
                                          dailyDataList[descIndex];

                                      String? description =
                                          dailyData['description'] as String?;

                                      // Create controller for description
                                      TextEditingController
                                          descriptionController =
                                          _controllers.putIfAbsent(
                                        '${dateFormatted}_description_$descIndex',
                                        () => TextEditingController(
                                            text: description ?? ''),
                                      );

                                      return TextField(
                                        controller: descriptionController,
                                        maxLines: 1,
                                        keyboardType: TextInputType.text,
                                        onChanged: (value) {
                                          _updateDescription(
                                              dateFormatted, value, descIndex);
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Development',
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: List.generate(1, (descIndex) {
                                      Map<String, dynamic> dailyData =
                                          dailyDataList[descIndex];

                                      String? hours =
                                          dailyData['hours'] as String?;

                                      // Create controller for hours
                                      TextEditingController hoursController =
                                          _controllers.putIfAbsent(
                                        '${dateFormatted}_hours_$descIndex',
                                        () => TextEditingController(
                                            text: hours ?? ''),
                                      );

                                      return Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: TextField(
                                              controller: hoursController,
                                              keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                  decimal: true),
                                              decoration: const InputDecoration(
                                                  hintText: ''),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 9,
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.app_registration_sharp),
                                              color: const Color.fromARGB(
                                                  255, 0, 138, 5),
                                              onPressed: () async {
                                                _updateHours(
                                                    dateFormatted,
                                                    hoursController.text,
                                                    descIndex);
                                              },
                                            ),
                                          ),
                                          const Divider(
                                            color:
                                                Color.fromARGB(255, 5, 16, 170),
                                            height: 10,
                                            thickness: 1,
                                          ),
                                          // Adding a sized box for separation
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
