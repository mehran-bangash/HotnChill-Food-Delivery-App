import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotnchill/model/user_model.dart';
import 'package:hotnchill/utils/utils.dart';

class UserService {

  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<void> addUserDetail(UserModel usermodel)async{

    try{
       _firestore.collection("UserInfo").doc(usermodel.uid).set(usermodel.toMap());
    }catch(e){
      Utils.toastMessage(e.toString());
    }
  }

  Future<UserModel?> getUserDetail(String uid) async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection("UserInfo").doc(uid).get();

      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      Utils.toastMessage("Error: ${e.toString()}");
    }
    return null;
  }

  Future<bool> updateImageOnly({required String uid, required String imageUrl}) async {
    try {
      await _firestore
          .collection("UserInfo")
          .doc(uid)
          .update({'imageUrl': imageUrl});
      return true;
    } catch (e) {
      Utils.toastMessage("Failed to update image: ${e.toString()}");
      return false;
    }
  }

  
  
  
  
  
  
  
}