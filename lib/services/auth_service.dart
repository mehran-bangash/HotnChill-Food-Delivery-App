
import 'package:firebase_auth/firebase_auth.dart';
import '../exceptions/auth_exception.dart';
import '../model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return UserModel(uid: userCredential.user!.uid, email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException.handleFirebaseAuthException(e.code);
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // No error, login successful
    } on FirebaseAuthException catch (e) {
      return e.message; // Return Firebase error message
    }
  }
  Future<String?> forgotPassword(String email)async{
    try{
   await   _auth.sendPasswordResetEmail(email: email);
   return null;
    }on FirebaseAuthException catch(e){
      return e.message;

    }


  }

}
