import 'dart:io';

import 'package:flutter/material.dart';
import 'product_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductEdit extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  ProductEdit({required this.productId, required this.productData});

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  late TextEditingController _productNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _unitPriceController;
  late TextEditingController _stockQuantityController;
  late TextEditingController _productImageController;
  late TextEditingController _productCategoryNameController;
  late TextEditingController _providerNameController;

  @override
  void initState() {
    super.initState();
    // Setting initial values for controllers
    _productNameController =
        TextEditingController(text: widget.productData['product_name'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.productData['description'] ?? '');
    _unitPriceController = TextEditingController(
        text: widget.productData['unit_price']?.toString() ?? '');
    _stockQuantityController = TextEditingController(
        text: widget.productData['stock_quantity']?.toString() ?? '');
    _productImageController =
        TextEditingController(text: widget.productData['product_image'] ?? '');
    _productCategoryNameController = TextEditingController(
        text: widget.productData['product_category_name'] ?? '');
    _providerNameController =
        TextEditingController(text: widget.productData['provider_name'] ?? '');
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final String oldImage =
          _productImageController.text; // Store the path of the old image
      setState(() {
        _productImageController.text =
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
        title: Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product ID: ${widget.productId}'),
            SizedBox(height: 16),
            _buildTextField('Product Name', _productNameController),
            _buildTextField('Description', _descriptionController),
            _buildTextField('Unit Price', _unitPriceController),
            _buildTextField('Stock Quantity', _stockQuantityController),
            _buildTextField('Product Image', _productImageController),
            TextButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            _buildTextField(
                'Product Category Name', _productCategoryNameController),
            _buildTextField('Provider Name', _providerNameController),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateProduct,
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

  void _updateProduct() async {
    String? imageURL = await _uploadImage(_productImageController.text);

    // Get the updated data from controllers
    String updatedProductName = _productNameController.text.trim();
    String updatedDescription = _descriptionController.text.trim();
    String updatedUnitPrice = _unitPriceController.text.trim();
    String updatedStockQuantity = _stockQuantityController.text.trim();
    // String updatedProductImage = _productImageController.text.trim();
    String updatedProductCategoryName =
        _productCategoryNameController.text.trim();
    String updatedProviderName = _providerNameController.text.trim();

    // Create a map with updated data
    Map<String, dynamic> updatedData = {
      'product_name': updatedProductName,
      'description': updatedDescription,
      'unit_price': updatedUnitPrice,
      'stock_quantity': updatedStockQuantity,
      'product_image': imageURL,
      'product_category_name': updatedProductCategoryName,
      'provider_name': updatedProviderName,
      // Add other fields as needed
    };

    // Call the updateProduct function from your ProductFsMethods class
    try {
      ProductFsMethods().updateProduct(widget.productId, updatedData);
      Navigator.of(context).pushReplacementNamed('productMain');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product updated successfully'),
        ),
      );
    } catch (e) {
      print("Error updating product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating product. Please try again.'),
        ),
      );
    }
  }
}
