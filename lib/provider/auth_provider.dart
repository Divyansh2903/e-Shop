import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      print("STATE CHANGED!!!!!!!!!!!!!!!!");
      notifyListeners();
    });
  }

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
