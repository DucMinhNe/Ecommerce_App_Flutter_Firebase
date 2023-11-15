import 'dart:io';

import 'package:flutter/material.dart';
import 'profile_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileEdit extends StatefulWidget {
  final String customerId;
  final Map<String, dynamic> customerData;

  ProfileEdit({required this.customerId, required this.customerData});

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _genderController;
  late TextEditingController _customerImageController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.customerData['first_name'] ?? '');
    _lastNameController =
        TextEditingController(text: widget.customerData['last_name'] ?? '');
    _emailController =
        TextEditingController(text: widget.customerData['email'] ?? '');

    _phoneNumberController =
        TextEditingController(text: widget.customerData['phone_number'] ?? '');
    _genderController =
        TextEditingController(text: widget.customerData['gender'] ?? '');
    _customerImageController = TextEditingController(
        text: widget.customerData['customer_image'] ?? '');
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final String oldImage =
          _customerImageController.text; // Store the path of the old image
      setState(() {
        _customerImageController.text =
            image.path; // Save the path to the new image
      });

      // Check if an old image exists, then delete it
      if (oldImage.isNotEmpty) {
        try {
          await firebase_storage.FirebaseStorage.instance
              .refFromURL(oldImage)
              .delete();
        } catch (e) {
          print("Error deleting old image: $e");
          // Handle error while deleting old image
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông Tin Cá Nhân'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Customer ID: ${widget.customerId}'),
            SizedBox(height: 16),
            _buildTextField('First Name', _firstNameController),
            _buildTextField('Last Name', _lastNameController),
            _buildTextField('Email', _emailController),
            _buildTextField('Phone Number', _phoneNumberController),
            _buildTextField('Gender', _genderController),
            // _buildTextField('Customer Image', _customerImageController),
            TextButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateCustomer,
              child: Text('Save Changes'),
            ),
          ],
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
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Future<String?> _uploadImage(String imagePath) async {
    try {
      File imageFile = File(imagePath); // Convert the imagePath to a File
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('customer_images/${DateTime.now().millisecondsSinceEpoch}');

      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg'); // Image type (JPEG, PNG...)

      await ref.putFile(imageFile, metadata); // Use the imageFile here

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void _updateCustomer() async {
    String? imageURL = await _uploadImage(_customerImageController.text);

    Map<String, dynamic> updatedData = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "email": _emailController.text,
      "phone_number": _phoneNumberController.text,
      "gender": _genderController.text,
      "customer_image": imageURL,
    };

    // Call the updateCustomer function from your CustomerFsMethods class
    try {
      ProfileFsMethods().updateCustomer(widget.customerId, updatedData);
      Navigator.of(context).pushReplacementNamed('homePage');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer updated successfully'),
        ),
      );
    } catch (e) {
      print("Error updating customer: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating customer. Please try again.'),
        ),
      );
    }
  }
}
