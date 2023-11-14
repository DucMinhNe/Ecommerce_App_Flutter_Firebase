import 'dart:io';

import 'package:flutter/material.dart';
import 'employee_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EmployeeEdit extends StatefulWidget {
  final String employeeId;
  final Map<String, dynamic> employeeData;

  EmployeeEdit({required this.employeeId, required this.employeeData});

  @override
  _EmployeeEditState createState() => _EmployeeEditState();
}

class _EmployeeEditState extends State<EmployeeEdit> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _jobTitleNameController;
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;
  late TextEditingController _hireDateController;
  late TextEditingController _salaryController;
  late TextEditingController _passwordController;
  late TextEditingController _employeeImageController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.employeeData['first_name'] ?? '');
    _lastNameController =
        TextEditingController(text: widget.employeeData['last_name'] ?? '');
    _emailController =
        TextEditingController(text: widget.employeeData['email'] ?? '');
    _addressController =
        TextEditingController(text: widget.employeeData['address'] ?? '');
    _phoneNumberController =
        TextEditingController(text: widget.employeeData['phone_number'] ?? '');
    _jobTitleNameController = TextEditingController(
        text: widget.employeeData['job_title_name'] ?? '');
    _birthDateController =
        TextEditingController(text: widget.employeeData['birth_date'] ?? '');
    _genderController =
        TextEditingController(text: widget.employeeData['gender'] ?? '');
    _hireDateController =
        TextEditingController(text: widget.employeeData['hire_date'] ?? '');
    _salaryController =
        TextEditingController(text: widget.employeeData['salary'] ?? '');
    _passwordController =
        TextEditingController(text: widget.employeeData['password'] ?? '');
    _employeeImageController = TextEditingController(
        text: widget.employeeData['employee_image'] ?? '');
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final String oldImage =
          _employeeImageController.text; // Store the path of the old image
      setState(() {
        _employeeImageController.text =
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
        title: Text('Edit Employee'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Employee ID: ${widget.employeeId}'),
            SizedBox(height: 16),
            _buildTextField('First Name', _firstNameController),
            _buildTextField('Last Name', _lastNameController),
            _buildTextField('Email', _emailController),
            _buildTextField('Address', _addressController),
            _buildTextField('Phone Number', _phoneNumberController),
            _buildTextField('Job Title Name', _jobTitleNameController),
            _buildTextField('Birth Date', _birthDateController),
            _buildTextField('Gender', _genderController),
            _buildTextField('Hire Date', _hireDateController),
            _buildTextField('Salary', _salaryController),
            _buildTextField('Password', _passwordController),
            _buildTextField('Employee Image', _employeeImageController),
            TextButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateEmployee,
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
          .child('employee_images/${DateTime.now().millisecondsSinceEpoch}');

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

  void _updateEmployee() async {
    String? imageURL = await _uploadImage(_employeeImageController.text);

    Map<String, dynamic> updatedData = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "email": _emailController.text,
      "address": _addressController.text,
      "phone_number": _phoneNumberController.text,
      "job_title_name": _jobTitleNameController.text,
      "birth_date": _birthDateController.text,
      "gender": _genderController.text,
      "hire_date": _hireDateController.text,
      "salary": _salaryController.text,
      "password": _passwordController.text,
      "employee_image": imageURL,
    };

    // Call the updateEmployee function from your EmployeeFsMethods class
    try {
      EmployeeFsMethods().updateEmployee(widget.employeeId, updatedData);
      Navigator.of(context).pushReplacementNamed('employeeMain');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Employee updated successfully'),
        ),
      );
    } catch (e) {
      print("Error updating employee: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating employee. Please try again.'),
        ),
      );
    }
  }
}
