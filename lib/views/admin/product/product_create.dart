import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'product_firestore.dart';

class ProductCreate extends StatefulWidget {
  const ProductCreate({Key? key}) : super(key: key);

  @override
  State<ProductCreate> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreate> {
  TextEditingController product_nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController unit_priceController = TextEditingController();
  TextEditingController stock_quantityController = TextEditingController();
  TextEditingController product_imageController = TextEditingController();
  TextEditingController product_category_nameController =
      TextEditingController();
  TextEditingController provider_nameController = TextEditingController();

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      product_imageController.text = image.path; // Save the path to the image
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
              _buildTextField("Product Name", product_nameController),
              _buildTextField("Description", descriptionController),
              _buildTextField("Unit Price", unit_priceController),
              _buildTextField("Stock Quantity", stock_quantityController),
              _buildTextField("Product Image", product_imageController),
              TextButton(
                // Button to pick an image
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              _buildTextField(
                  "Product Category Name", product_category_nameController),
              _buildTextField("Provider Name", provider_nameController),
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
        // Text(
        //   label,
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontSize: 20.0,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Function to upload image to Firebase Storage
  Future<String?> _uploadImage(String imagePath) async {
    try {
      File imageFile = File(imagePath); // Convert the imagePath to a File
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('product_images/${DateTime.now().millisecondsSinceEpoch}');

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

  void _uploadData() async {
    try {
      String? imageURL = await _uploadImage(product_imageController.text);

      if (imageURL != null) {
        Map<String, dynamic> uploadData = {
          "product_name": product_nameController.text,
          "description": descriptionController.text,
          "unit_price": unit_priceController.text,
          "stock_quantity": int.parse(stock_quantityController.text),
          "product_image": imageURL, // Sử dụng URL của hình đã tải lên Firebase
          "product_category_name": product_category_nameController.text,
          "provider_name": provider_nameController.text,
        };

        await ProductFsMethods().addProducts(uploadData);
        Navigator.of(context).pushReplacementNamed('productMain');
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
