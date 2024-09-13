import 'package:firebase_auth/firebase_auth.dart';
class AuthServices{
  User? _user;
  User? user(){
    return _user;
  }

  final  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthServices();
  Future<bool> login(String email, String password) async {
  try {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
        if (credential.user != null) {
            _user = credential.user;
             return true;
        }  
  }
  catch(e){
print(e);

  }
  return false;
}
}