import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:intl/intl.dart';

class FeatureRequestScreen extends StatefulWidget {
  const FeatureRequestScreen({super.key});

  @override
  _FeatureRequestScreenState createState() => _FeatureRequestScreenState();
}

class _FeatureRequestScreenState extends State<FeatureRequestScreen> {
  final List<List<TextEditingController>> _controllers = List.generate(
    5,
    (index) => List.generate(
      7,
      (index) => TextEditingController(),
    ),
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final List<DateTime> _months =
      List<DateTime>.generate(12, (i) => DateTime(DateTime.now().year, i + 1));

  final Map<String, TextEditingController> _hoursControllers = {};

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _initData();
  }

  Future<void> _initData() async {
    for (var j = 0; j < 3; j++) {
      for (var i = 0; i < _controllers[j].length; i++) {
        DocumentSnapshot doc = await _firestore
            .collection('featureRequests${j + 1}')
            .doc('request$i')
            .get();

        var data = doc.data() as Map<String, dynamic>?;

        _controllers[j][i].text =
            doc.exists && data != null && data['text'] != null
                ? data['text']
                : '';
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Research & Development'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: _buildTopWayCarousel(0),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: _buildTopWayCarousel(1),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: _buildTopWayCarousel(2),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: _buildTopWayCarousel(3),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: _buildTopWayCarousel(4),
          ),
          const SizedBox(height: 10),
          _buildBillingCardCarousel(),
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

  Widget _buildTopWayCarousel(int carouselIndex) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _controllers[carouselIndex].length,
      itemBuilder: (BuildContext context, int index) {
        return _buildTopWayItem(
            _controllers[carouselIndex][index], index, carouselIndex);
      },
    );
  }

  Widget _buildTopWayItem(
      TextEditingController controller, int index, int carouselIndex) {
    var collection = 'featureRequests${carouselIndex + 1}';
    var document = 'request$index';
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: controller,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      onEditingComplete: () {
                        _firestore.collection(collection).doc(document).set(
                            {'text': controller.text}, SetOptions(merge: true));
                        FocusScope.of(context).unfocus();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter feature or bug',
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection(collection)
                            .doc(document)
                            .snapshots(),
                        builder: (context, snapshot) {
                          int likeCount = 0;

                          if (snapshot.hasData) {
                            var data =
                                snapshot.data!.data() as Map<String, dynamic>?;

                            if (data != null && data.containsKey('votes')) {
                              likeCount =
                                  (data['votes'] as Map<String, dynamic>)
                                      .values
                                      .where((v) => v == true)
                                      .length;
                            }
                          }
                          return Text('$likeCount');
                        }),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_up_outlined),
                      color: const Color.fromARGB(255, 0, 138, 5),
                      onPressed: () async {
                        DocumentSnapshot doc = await _firestore
                            .collection(collection)
                            .doc(document)
                            .get();
                        Map<String, dynamic>? docData =
                            doc.data() as Map<String, dynamic>?;

                        Map<String, bool?> votes =
                            docData != null && docData.containsKey('votes')
                                ? Map<String, bool?>.from(docData['votes'])
                                : {};
                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        votes[uid] = votes[uid] != true ? true : null;
                        _firestore
                            .collection(collection)
                            .doc(document)
                            .set({'votes': votes}, SetOptions(merge: true));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                      color: const Color.fromARGB(255, 178, 0, 0),
                      onPressed: () async {
                        DocumentSnapshot doc = await _firestore
                            .collection(collection)
                            .doc(document)
                            .get();
                        Map<String, dynamic>? docData =
                            doc.data() as Map<String, dynamic>?;
                        Map<String, bool?> votes =
                            docData != null && docData.containsKey('votes')
                                ? Map<String, bool?>.from(docData['votes'])
                                : {};
                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        votes[uid] = (votes[uid] != false ? false : null);
                        _firestore
                            .collection(collection)
                            .doc(document)
                            .set({'votes': votes}, SetOptions(merge: true));
                      },
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection(collection)
                            .doc(document)
                            .snapshots(),
                        builder: (context, snapshot) {
                          int dislikeCount = 0;
                          if (snapshot.hasData) {
                            var data =
                                snapshot.data!.data() as Map<String, dynamic>?;

                            if (data != null && data.containsKey('votes')) {
                              dislikeCount =
                                  (data['votes'] as Map<String, dynamic>)
                                      .values
                                      .where((v) => v == false)
                                      .length;
                            }
                          }
                          return Text('$dislikeCount');
                        }),
                  ],
                )
              ]),
            )));
  }

  @override
  void dispose() {
    for (var controller in _hoursControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildBillingCardCarousel() {
    return SizedBox(
      height: 600,
      child: PageView.builder(
        controller: PageController(viewportFraction: 1.04),
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          return _buildBillingCard(_months[index]);
        },
      ),
    );
  }

  Widget _buildBillingCard(DateTime month) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
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
                    DateTime day = DateTime(month.year, month.month, index + 1);

                    TextEditingController controller =
                        _hoursControllers.putIfAbsent(
                      DateFormat('yyyy-MM-dd').format(day),
                      () => TextEditingController(),
                    );

                    TextEditingController hoursController =
                        _hoursControllers.putIfAbsent(
                      '${DateFormat('yyyy-MM-dd').format(day)}_hours',
                      () => TextEditingController(),
                    );

                    _firestore.collection('billing').doc(user!.uid).get().then(
                      (doc) {
                        if (doc.exists) {
                          var data = doc.data();
                          if (data != null &&
                              data.containsKey(
                                  DateFormat('yyyy-MM-dd').format(day))) {
                            controller.text =
                                data[DateFormat('yyyy-MM-dd').format(day)];
                          }
                          if (data!.containsKey(
                              '${DateFormat('yyyy-MM-dd').format(day)}_hours')) {
                            hoursController.text = data[
                                    '${DateFormat('yyyy-MM-dd').format(day)}_hours']
                                .toString();
                          }
                        }
                      },
                    );

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text((index + 1).toString()),
                            ),
                            Expanded(
                              flex: 9,
                              child: SingleChildScrollView(
                                child: TextField(
                                  controller: controller,
                                  maxLines: 2,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (value) {
                                    _firestore
                                        .collection('billing')
                                        .doc(user!.uid)
                                        .set({
                                      DateFormat('yyyy-MM-dd').format(day):
                                          value
                                    }, SetOptions(merge: true));
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Development',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: hoursController,
                                keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true), // Include decimal
                                decoration: const InputDecoration(
                                  hintText: 'Hours',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(Icons.app_registration_sharp),
                                color: const Color.fromARGB(255, 0, 138, 5),
                                onPressed: () async {
                                  // New value to add
                                  var hoursToAdd = hoursController.text is int
                                      ? (hoursController.text as int).toDouble()
                                      : double.tryParse(hoursController.text);

                                  if (hoursToAdd == null) {
                                    // Invalid number entered
                                    print(
                                        "Invalid hours value: ${hoursController.text}");
                                    return;
                                  }

                                  DocumentSnapshot doc = await _firestore
                                      .collection('billing')
                                      .doc(user!.uid)
                                      .get();
                                  Map<String, dynamic>? docData =
                                      doc.data() as Map<String, dynamic>?;

                                  // Get existing hours value from database
                                  var existingHoursKey =
                                      '${DateFormat('yyyy-MM-dd').format(day)}_hours';

                                  // We don't need to fetch the existing value here as we are overwriting it

                                  await _firestore
                                      .collection('billing')
                                      .doc(user!.uid)
                                      .set({
                                    existingHoursKey: hoursToAdd
                                        .toString() // Set the new value
                                  }, SetOptions(merge: true));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
