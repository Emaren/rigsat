import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'hours/hours_entry_page.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  User? get currentUser => _user;
  String? get currentUserId => _auth.currentUser?.uid;
  String? displayName;
  String? firstName;
  String? role;
  String? getRole() => role;

  AuthService() {
    print('Initializing AuthService...');
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _user = null;
        print('No user currently signed in.');
      } else {
        _user = user;
        print('User signed in: ${user.uid}');
      }
      notifyListeners();
    });
  }

  Future<String?> getCurrentUserDisplayNameFromFirestore() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String? displayName = await getUserDisplayName(user.uid);

      return displayName;
    } else {
      return null;
    }
  }

  Future<String?> getUserDisplayName(String uid) async {
    try {
      DocumentSnapshot userDocSnapshot =
          await firestore.collection('users').doc(uid).get();
      String? displayName =
          (userDocSnapshot.data() as Map<String, dynamic>)['displayName'];

      return displayName;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> navigateToHoursEntryPage(BuildContext context) async {
    if (_user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HoursEntryPage(),
          ));
    } else {}
  }

  Future<UserCredential> signUpWithEmail(
      String email,
      String password,
      String displayName,
      String firstName,
      String lastName,
      String role) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (userCredential.user != null) {
        await _userCollection.doc(userCredential.user?.uid).set({
          'creationTime': FieldValue.serverTimestamp(),
          'email': email,
          'displayName': displayName,
          'firstName': firstName,
          'lastName': lastName,
          'role': role,
        });
        print(
            'User info: ID=${user?.uid}, displayName=$displayName, email=$email, role=$role');

        DocumentSnapshot userDoc =
            await _userCollection.doc(userCredential.user?.uid).get();

        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          this.displayName = data['displayName'];
          this.role = data['role'];
        }

        notifyListeners();
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      notifyListeners();

      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      print('Attempting to sign in user: $email...');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      DocumentSnapshot userDoc =
          await _userCollection.doc(userCredential.user?.uid).get();

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

      if (data != null) {
        displayName = data['displayName'] ?? 'N/A';
        firstName = data['firstName'] ?? 'N/A';
        role = data['role'] ?? 'N/A';
      }

      print(
          'User signed in successfully: ID=${userCredential.user?.uid}, displayName=$displayName, firstName=$firstName, role=$role');

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in user: ${e.code}, ${e.message}');
      notifyListeners();
    } catch (e) {
      print('An unknown error occurred: $e');
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();

    displayName = null;
    role = null;

    notifyListeners();
  }

  Future<Map<String, String?>> fetchUserDetails() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _userCollection.doc(currentUser.uid).get();
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data != null) {
        displayName = data['displayName'] ?? 'N/A';
        firstName = data['firstName'] ?? 'N/A';
        role = data['role'] ?? 'N/A';
      }

      print(
          'User info signin in: displayName=$displayName, firstName=$firstName, role=$role');
      return {'displayName': displayName, 'firstName': firstName, 'role': role};
    }
    return {'displayName': null, 'firstName': null, 'role': null};
  }

  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      throw Exception('No user is signed in.');
    }
  }
}
