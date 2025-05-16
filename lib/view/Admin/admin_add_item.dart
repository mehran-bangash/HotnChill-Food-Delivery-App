import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotnchill/resources/components/admin_detail_text_field.dart';
import 'package:hotnchill/resources/components/admin_text_field.dart';
import 'package:hotnchill/view_model/admin_add_item_view_model.dart';

class AdminAddItem extends StatelessWidget {
  const AdminAddItem({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminAddItemViewModel>(context);

    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 8),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.arrow_back, size: 33),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.13),
                      child: const Text(
                        "Add Item",
                        style: TextStyle(
                          fontFamily: "poppins",
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, top: 8),
                child: Text(
                  "Upload the Item Picture",
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () async {
                  await viewModel.pickImage();
                },
                child: Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 1.5),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: viewModel.imageFile != null
                        ? Image.file(viewModel.imageFile!, fit: BoxFit.cover)
                        : const Center(
                      child: Icon(Icons.camera_alt, color: Colors.black54),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  await viewModel.uploadImage();
                },
                child: Center(
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Upload Image",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    AdminTextField(title: "Item Name", controller: viewModel.nameController),
                    AdminTextField(title: "Item Price", controller: viewModel.priceController),
                    AdminDetailTextField(title: "Item Detail", controller: viewModel.detailController),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Select Category",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.shade300,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          alignment: Alignment.center,
                          hint: const Text('Select Category'),
                          value: viewModel.selectedValue,
                          items: viewModel.foodItems.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) viewModel.setSelectedValue(v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  await viewModel.addItemFireStore();
                },
                child: Center(
                  child: Material(
                    elevation: 10,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      height: 40,
                      width: 160,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
