import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFsMethods {
  Future addProducts(Map<String, dynamic> productInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Product")
        .doc()
        .set(productInfoMap);
  }

  Future<QuerySnapshot> getAllProducts() {
    return FirebaseFirestore.instance.collection("Product").get().then(
      (value) {
        return value;
      },
      onError: (error) {
        // Xử lý ngoại lệ nếu có
        print("Error fetching products: $error");
        throw error; // Đẩy ngoại lệ lại sau khi xử lý
      },
    );
  }

  Future<void> updateProduct(
      String productId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection("Product")
          .doc(productId)
          .update(updatedData);
    } catch (e) {
      // Handle any errors that occur during the update
      print("Error updating product: $e");
      throw e; // Throw the error for handling in the calling code
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Product")
          .doc(productId)
          .delete();
    } catch (e) {
      // Handle any errors that occur during the deletion
      print("Error deleting product: $e");
      throw e; // Throw the error for handling in the calling code
    }
  }

  Future<QuerySnapshot> searchProductByName(String productName) {
    return FirebaseFirestore.instance
        .collection('Product')
        .where('product_name', isEqualTo: productName)
        .get()
        .then(
      (value) {
        return value;
      },
      onError: (error) {
        print("Error searching for products: $error");
        throw error; // Đẩy ngoại lệ lại sau khi xử lý
      },
    );
  }
}
