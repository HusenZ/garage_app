import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerGarage({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      // Check in users collection
      final userExists =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (userExists.docs.isNotEmpty) return "Email already exists in users.";

      // Check in garage collection
      final garageExists =
          await _firestore
              .collection('garage')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (garageExists.docs.isNotEmpty)
        return "Email already exists in garage.";

      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Save in Firestore garage collection
      await _firestore.collection('garage').doc(uid).set({
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': 'garage',
        'createdAt': Timestamp.now(),
      });
      await _setLoginStatus(true);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<String> loginGarageUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _setLoginStatus(true);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed.";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<String> registerUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      final userSnap =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      final garageSnap =
          await _firestore
              .collection('garage')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (userSnap.docs.isNotEmpty || garageSnap.docs.isNotEmpty) {
        return "Email already exists";
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'username': username,
        'email': email,
        'role': 'customer',
        'createdAt': Timestamp.now(),
      });

      await _setLoginStatus(true); // Save login status
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    } catch (e) {
      return "Something went wrong";
    }
  }

  Future<String> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _setLoginStatus(true); // Save login status
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed";
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
    await _setLoginStatus(false);
  }

  Future<void> _setLoginStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
