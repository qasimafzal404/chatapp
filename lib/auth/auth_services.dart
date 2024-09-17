import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  User? _user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthServices() {
    // Initialize user state
    _firebaseAuth.authStateChanges().listen(authStateChanges);
  }

  // Return current user
  User? user() {
    return _user;
  }

  // Stream for auth state changes
  Stream<User?> authStateChangesStream() {
    return _firebaseAuth.authStateChanges();
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
Future <bool> signup(String email, String password) async {
  try {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (credential.user != null) {
      _user = credential.user;
      return true;
    }
  } catch (e) {
    print(e);
  }
  return false;
}
  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Update the user state on auth state changes
  void authStateChanges(User? user) {
    _user = user;
  }
}
