import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'auth_service.dart';
import 'hours/hours_entry_page.dart';
import 'mini timesheet widget/mini_timesheet_utils.dart';
import 'review_timesheet_page.dart';
import 'sign_up_page.dart';
import 'timesheet_data.dart';
import 'user_list_page.dart';

class ManagerHomePage extends StatefulWidget {
  final List<TimesheetData>? timesheetData;
  final String uid;

  const ManagerHomePage({
    Key? key,
    this.timesheetData,
    required this.uid,
  }) : super(key: key);

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  String? role;

  late final displayName;

  String title = 'Manager Home';
  final List<String> userRoles = [
    'Owner',
    'Manager',
    'Administration',
    'Secretary',
    'Sales',
    'Supervisor',
    'Field Tech',
    'Shop Tech',
    'Tech',
    'Technician',
    'Employee',
    'Client',
    'Customer',
    'Vendor',
    'Guest'
  ];
  List<PayDate> payDates = [];

  List<Map<String, dynamic>> hourEntriesData = [];

  String userId = '';
  String userDisplayName = 'Unknown';
  DateTime currentPayPeriodStart = calculateStartDate();
  List<DateTime> payPeriodDates = [];

  @override
  void initState() {
    super.initState();
    payPeriodDates = generatePayPeriodDates(currentPayPeriodStart);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserListPage(
                          authService: _authService,
                          emailController: _emailController,
                          nameController: _displayNameController,
                          userRoles: const [
                            'Admin',
                            'Owner',
                            'Manager',
                            'Administration',
                            'Secretary',
                            'Sales',
                            'Supervisor',
                            'Field Tech',
                            'Shop Tech',
                            'Tech',
                            'Technician',
                            'Employee',
                            'Client',
                            'Customer',
                            'Vendor'
                          ],
                          createUser: (BuildContext) {},
                        ),
                      ),
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 33, 55, 73),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(26),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people,
                              size: 48,
                              color: Color.fromARGB(255, 255, 255, 255)),
                          SizedBox(height: 16),
                          Text(
                            'Users',
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 246, 245, 245)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add_alt_1,
                              size: 48,
                              color: Color.fromARGB(255, 132, 14, 14)),
                          SizedBox(height: 16),
                          Text(
                            'Create User',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewTimesheetPage(
                          timesheetData: widget.timesheetData ?? [],
                          uid: widget.uid,
                          authService: _authService,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Review Timesheets',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ReviewTicketsPage(),
                    //   ),
                    // );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Review Tickets &\n Safety Documents',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    // context,
                    // MaterialPageRoute(
                    // builder: (context) => const JobListPage(),
                    // ),
                    // );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'View Jobs List &\n Assign Jobs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const SmartPSS(),
                    //   ),
                    // );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Smart PSS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
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
