import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hotnchill/model/user_model.dart';
import 'package:hotnchill/services/cloudinary_services.dart';
import 'package:hotnchill/services/user_service.dart';
import 'package:hotnchill/view_model/auth_view_model.dart';
import 'package:image_picker/image_picker.dart';



import '../utils/utils.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? _user;
  File? _imageFile;
  String? _imageUrl;

  File? get imageFile => _imageFile;
  String? get imageUrl => _imageUrl;
  final authViewModel= AuthViewModel();

  final CloudinaryService _cloudinaryService = CloudinaryService();
  UserModel? get user => _user;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFilePath = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFilePath != null) {
        _imageFile = File(pickedFilePath.path);
        notifyListeners();
      }
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
  }

  Future<void> uploadedProfileImage() async {
   try{
     if (_imageFile == null) return;
     String? uploadedUrl = await _cloudinaryService.uploadProfileImage(
       _imageFile!,
     );
     if (uploadedUrl != null) {
       _imageUrl = uploadedUrl;
       notifyListeners();
       Utils.toastMessage("image Uploaded SuccessFully");
     }
   }catch(e){
     Utils.toastMessage("Error:${e.toString()}");
   }
  }
  Future<void> updateUserDetail() async {
    if (_user == null || _imageUrl == null) {
      Utils.toastMessage("No user or image to update.");
      return;
    }
    try {
      bool success = await UserService().updateImageOnly(
        uid: _user!.uid??"",
        imageUrl: _imageUrl!,
      );

      if (success) {
        _user = UserModel(
          uid: _user!.uid,
          displayName: _user!.displayName,
          email: _user!.email,
          imageUrl: _imageUrl,
        );
        notifyListeners();
        Utils.toastMessage("Profile image updated successfully!");
      }
    } catch (e) {
      Utils.toastMessage("Update failed: ${e.toString()}");
    }
  }



  Future<void> addUserDetail() async {
    try {
      String? uid = authViewModel.currentUserId;
      UserModel userModel = UserModel(
        uid: uid,
        displayName: nameController.text,
        email: emailController.text,
      );

      await UserService().addUserDetail(userModel);
      _user = userModel;
      notifyListeners();
    //  Utils.toastMessage("User Information Added Successfully!");
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
  }

  Future<void> fetchUserDetail(String uid) async {
    _user = await UserService().getUserDetail(uid);
    notifyListeners();
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();

    notifyListeners();
  }
}
