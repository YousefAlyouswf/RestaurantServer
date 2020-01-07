import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurantapp/models/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //create user obj base in FirebaseUser
  User _userFromFireBase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user steam
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFireBase);
  }

  //Sign in with E-mail and Password
  Future siginFirebaseWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFireBase(user);
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  //Sign out
  Future signOUt() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


}
