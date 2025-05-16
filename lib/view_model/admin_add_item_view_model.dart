
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotnchill/model/item_model.dart';
import 'package:hotnchill/repository/item_repository.dart';
import 'package:hotnchill/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

import '../services/cloudinary_services.dart';

class AdminAddItemViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;
  File? get imageFile => _imageFile;
  String? get imageUrl => _imageUrl;
  String? selectedValue;
  List<String> foodItems = ['Icecream', 'Pizza', 'ChickenHot', 'Burger'];
  void setSelectedValue(String? value) {
    selectedValue = value;
    notifyListeners();
  }
  final CloudinaryService _cloudinaryService = CloudinaryService();
  ItemRepository itemRepository=ItemRepository();
  // Select Image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Upload Image to Cloudinary
  Future<void> uploadImage() async {
    if (_imageFile == null) return;
    String? uploadedUrl = await _cloudinaryService.uploadImage(_imageFile!);
    if (uploadedUrl != null) {
      _imageUrl = uploadedUrl;
      notifyListeners();
    }
  }
  Future<void> addItemFireStore() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        detailController.text.isEmpty ||
        _imageFile==null ||
        selectedValue == null) {
       Utils.toastMessage("Error: All fields are required!",gravity: ToastGravity.CENTER);
      return;
    }

    String uid = randomAlpha(8); // Generate random ID

    ItemModel itemModel = ItemModel(
      id: uid,
      name: nameController.text,
      price: priceController.text,
      detail: detailController.text,
      category: selectedValue!,
      imageUrl: _imageUrl ?? ""
    );

    await itemRepository.addItem(selectedValue!,itemModel);
    clearFields();
    notifyListeners();
  }
  void clearFields() {
    nameController.clear();
    priceController.clear();
    detailController.clear();
    _imageFile = null;
    _imageUrl = null;
    notifyListeners();
  }
  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    detailController.dispose();
    super.dispose();
  }
}
