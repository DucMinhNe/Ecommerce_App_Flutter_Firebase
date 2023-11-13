import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();
  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<Map<String, dynamic>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      res = {'user': user};
    } on FirebaseAuthException catch (e) {
      // ... (no change here)
    }
    return res;
  }

  //TODO :Sign Up With Email Password
  Future<Map<String, dynamic>> createUserWithEmailPassword(
      {required String? email, required String? password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential? userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: password!);
      User? user = userCredential.user;
      res = {
        'user': user,
      };
    } on FirebaseAuthException catch (e) {
      print("-----------------------");
      print(e.code);
      print("-----------------------");
      switch (e.code) {
        case 'invalid-email':
          res = {'error': 'Invalid Email....'};
          break;
        case 'weak-password':
          res = {'error': 'Your Password is Weak....'};
          break;
        case 'operation-not-allowed':
          res = {'error': 'Server is temporary off....'};
          break;
        case 'email-already-in-use':
          res = {'error': 'Please select another email....'};
          break;
      }
    }
    return res;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> res = {};
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        User? user = userCredential.user;

        res = {'user': user};
      }
    } catch (error) {
      print("Error during Google Sign-In: $error");
      // Handle the error as needed
      res = {'error': 'Google Sign-In Failed'};
    }
    return res;
  }
}
