import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'customer_firestore.dart';

class CustomerCreate extends StatefulWidget {
  const CustomerCreate({Key? key}) : super(key: key);

  @override
  State<CustomerCreate> createState() => _CustomerCreateState();
}

class _CustomerCreateState extends State<CustomerCreate> {
  TextEditingController first_nameController = TextEditingController();
  TextEditingController last_nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phone_numberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  TextEditingController customer_imageController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      customer_imageController.text = image.path; // Save the path to the image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create/Write Data"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("First Name", first_nameController),
              _buildTextField("Last Name", last_nameController),
              _buildTextField("Email", emailController),
              _buildTextField("Phone Number", phone_numberController),
              _buildTextField("Gender", genderController),
              // _buildTextField("Password", passwordController),
              // _buildTextField("Address", addressController),
              _buildTextField("Customer Image", customer_imageController),
              TextButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _uploadData();
                },
                child: Text('Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Future<String?> _uploadImage(String imagePath) async {
    try {
      File imageFile = File(imagePath);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('customer_images/${DateTime.now().millisecondsSinceEpoch}');

      final metadata =
          firebase_storage.SettableMetadata(contentType: 'image/jpeg');

      await ref.putFile(imageFile, metadata);

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void _uploadData() async {
    try {
      String? imageURL = await _uploadImage(customer_imageController.text);

      if (imageURL != null) {
        Map<String, dynamic> uploadData = {
          "first_name": first_nameController.text,
          "last_name": last_nameController.text,
          "email": emailController.text,
          "phone_number": phone_numberController.text,
          "gender": genderController.text,
          // "password": passwordController.text,
          // "address_customer": addressController.text,
          "customer_image": imageURL,
        };

        await CustomerFsMethods().addCustomers(uploadData);
        Navigator.of(context).pushReplacementNamed('customerMain');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm Thành Công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải ảnh lên. Vui lòng thử lại.')),
        );
      }
    } catch (e) {
      print("Error uploading data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm dữ liệu. Vui lòng thử lại.')),
      );
    }
  }
}
