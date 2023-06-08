import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';
import 'package:rigsat/products/first_screen.dart';
import 'package:rigsat/r_and_d/feature_request_screen.dart';
import 'assets.dart';
import 'auth_service.dart';
import 'firestore_mini_timesheet_widget.dart';
import 'log_out_page.dart';
import 'employee_home_page.dart';
import 'customer_home_page.dart';
import 'manager_home_page.dart';
import 'rigsatchat.dart';
import 'services/second_screen.dart';
import 'settings_screen.dart';
import 'tickets.dart';
import 'timesheets.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  _HiddenDrawerState createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No user';

  @override
  void initState() {
    super.initState();
    print('HiddenDrawerState initState');
  }

  @override
  Widget build(BuildContext context) {
    print('HiddenDrawerState build');
    final userDetails = Provider.of<AuthService>(context);

    Widget homePage = const SizedBox.shrink();

    TextStyle baseStyle =
        TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0);

    return FutureBuilder<Map<String, String?>>(
        future: userDetails.fetchUserDetails(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitFadingGrid(
                color: Color.fromARGB(255, 27, 2, 191),
                size: 50.0,
              ),
            );
          } else {
            String? displayName = snapshot.data?['displayName']?.trim();
            String? firstName = snapshot.data?['firstName']?.trim();
            String? role = snapshot.data?['role'];
            print(
                'DisplayName: $displayName, FirstName: $firstName, Role: $role');
            String? displayedName =
                displayName?.isEmpty ?? true ? firstName : displayName;

            print('DisplayedName after check: $displayedName');

            switch (role) {
              case 'Admin':
              case 'Owner':
              case 'Manager':
              case 'Administration':
              case 'Accounting':
              case 'Secretary':
              case 'Supervisor':
                homePage = const ManagerHomePage(
                  // homePage = const FeatureRequestScreen(
                  uid: '',
                );
                break;
              case 'Employee':
              case 'Sales':
                homePage = const EmployeeHomePage(
                  role: '',
                );
                break;
              case 'Client':
              case 'Customer':
              case 'Vendor':
              case 'Guest':
                homePage = const CustomerHomePage();
                break;
              default:
                // Handle unknown roles or assign a default home page
                break;
            }

            List<ScreenHiddenDrawer> items = [
              ScreenHiddenDrawer(
                ItemHiddenMenu(
                  name: '$displayedName, $role',
                  baseStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 19),
                  selectedStyle: const TextStyle(),
                ),
                Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.blueGrey,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          context.read<AuthService>().signOut(context);
                        },
                      ),
                    ],
                  ),
                  body: homePage,
                ),
              ),
              if ([
                'Admin',
                'Owner',
                'Manager',
                'Administration',
                'Accounting',
                'Secretary',
                'Supervisor'
              ].contains(role)) ...[
                ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: 'Review Hours',
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      selectedStyle: const TextStyle(color: Colors.white)),
                  Scaffold(
                    body: Center(
                      child: FirestoreMiniTimesheetWidget(),
                    ),
                  ),
                ),
              ],
              if (role == 'Admin' ||
                  role == 'Owner' ||
                  role == 'Manager' ||
                  role == 'Employee' ||
                  role == 'Sales') ...[
                ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: 'Timesheets',
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      selectedStyle: const TextStyle(color: Colors.white)),
                  const Timesheets(),
                ),
                ScreenHiddenDrawer(
                    ItemHiddenMenu(
                        name: 'Assets',
                        baseStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                        selectedStyle: const TextStyle(color: Colors.white)),
                    const Assets(
                      title: '',
                      userDocRef: null,
                    )),
                ScreenHiddenDrawer(
                    ItemHiddenMenu(
                        name: 'Tickets',
                        baseStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                        selectedStyle: const TextStyle(color: Colors.white)),
                    const Tickets()),
                ScreenHiddenDrawer(
                    ItemHiddenMenu(
                        name: 'RigSatChat',
                        baseStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                        selectedStyle: const TextStyle(color: Colors.white)),
                    const RigSatChat()),
                ScreenHiddenDrawer(
                    ItemHiddenMenu(
                        name: 'R&D',
                        baseStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                        selectedStyle: const TextStyle(color: Colors.white)),
                    const FeatureRequestScreen()),
                ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: 'Rentals',
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      selectedStyle: const TextStyle(color: Colors.white)),
                  const Scaffold(
                    body: Center(
                      child: FirstScreen(),
                    ),
                  ),
                ),
                ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: 'Services',
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      selectedStyle: const TextStyle(color: Colors.white)),
                  const Scaffold(
                    body: Center(
                      child: SecondScreen(),
                    ),
                  ),
                ),
              ],
              if (role == 'Client' ||
                  role == 'Customer' ||
                  role == 'Vendor' ||
                  role == 'Guest') ...[
                ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: 'Rentals',
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      selectedStyle: const TextStyle(color: Colors.white)),
                  const Scaffold(
                    body: Center(
                      child: FirstScreen(),
                    ),
                  ),
                ),
                ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: 'Services',
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      selectedStyle: const TextStyle(color: Colors.white)),
                  const Scaffold(
                    body: Center(
                      child: SecondScreen(),
                    ),
                  ),
                ),
              ],
              ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: 'Settings',
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      selectedStyle: const TextStyle(color: Colors.white)),
                  const SettingsScreen()),
              ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: "Log Out",
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      colorLineSelected: Colors.blue,
                      selectedStyle: const TextStyle(color: Colors.white)),
                  const LogOutPage())
            ];

            return HiddenDrawerMenu(
              backgroundColorMenu: Colors.blueGrey,
              backgroundColorAppBar: Colors.blueGrey,
              screens: items,
            );
          }
        });
  }
}
