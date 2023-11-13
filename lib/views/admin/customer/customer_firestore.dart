import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerFsMethods {
  Future addCustomers(Map<String, dynamic> customerInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Customer")
        .doc()
        .set(customerInfoMap);
  }

  Future<void> addCustomerWithAddress(Map<String, dynamic> customerInfoMap,
      Map<String, dynamic> addressInfoMap) async {
    // Tạo một tài liệu mới trong collection "Customer"
    DocumentReference customerDocRef = await FirebaseFirestore.instance
        .collection("Customer")
        .add(customerInfoMap);

    // Lấy ID của tài liệu vừa tạo
    String customerId = customerDocRef.id;

    // Tạo một collection "address_customer" trong tài liệu mới
    CollectionReference addressCollectionRef =
        customerDocRef.collection("address_customer");

    // Thêm dữ liệu vào collection "address_customer"
    await addressCollectionRef.add(addressInfoMap);
  }

  Future<QuerySnapshot> getAllCustomers() {
    return FirebaseFirestore.instance.collection("Customer").get().then(
      (value) {
        return value;
      },
      onError: (error) {
        // Xử lý ngoại lệ nếu có
        print("Error fetching customers: $error");
        throw error; // Đẩy ngoại lệ lại sau khi xử lý
      },
    );
  }

  Future<void> updateCustomer(
      String customerId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection("Customer")
          .doc(customerId)
          .update(updatedData);
    } catch (e) {
      // Handle any errors that occur during the update
      print("Error updating customer: $e");
      throw e; // Throw the error for handling in the calling code
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Customer")
          .doc(customerId)
          .delete();
    } catch (e) {
      // Handle any errors that occur during the deletion
      print("Error deleting customer: $e");
      throw e; // Throw the error for handling in the calling code
    }
  }
}
