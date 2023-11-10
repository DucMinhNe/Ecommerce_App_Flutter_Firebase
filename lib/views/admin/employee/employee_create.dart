import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'employee_firestore.dart';

class EmployeeCreate extends StatefulWidget {
  const EmployeeCreate({Key? key}) : super(key: key);

  @override
  State<EmployeeCreate> createState() => _EmployeeCreateState();
}

class _EmployeeCreateState extends State<EmployeeCreate> {
  TextEditingController first_nameController = TextEditingController();
  TextEditingController last_nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phone_numberController = TextEditingController();
  TextEditingController job_title_nameController = TextEditingController();
  TextEditingController birth_dateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController hire_dateController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController employee_imageController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      employee_imageController.text = image.path; // Save the path to the image
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
              _buildTextField("Address", addressController),
              _buildTextField("Phone Number", phone_numberController),
              _buildTextField("Job Title Name", job_title_nameController),
              _buildTextField("Birth Date", birth_dateController),
              _buildTextField("Gender", genderController),
              _buildTextField("Hire Date", hire_dateController),
              _buildTextField("Salary", salaryController),
              _buildTextField("Password", passwordController),
              _buildTextField("Employee Image", employee_imageController),
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
          .child('employee_images/${DateTime.now().millisecondsSinceEpoch}');

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
      String? imageURL = await _uploadImage(employee_imageController.text);

      if (imageURL != null) {
        Map<String, dynamic> uploadData = {
          "first_name": first_nameController.text,
          "last_name": last_nameController.text,
          "email": emailController.text,
          "address": addressController.text,
          "phone_number": phone_numberController.text,
          "job_title_name": job_title_nameController.text,
          "birth_date": birth_dateController.text,
          "gender": genderController.text,
          "hire_date": hire_dateController.text,
          "salary": salaryController.text,
          "password": passwordController.text,
          "employee_image": imageURL,
        };

        await EmployeeFsMethods().addEmployees(uploadData);
        Navigator.of(context).pushReplacementNamed('employeeMain');
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
