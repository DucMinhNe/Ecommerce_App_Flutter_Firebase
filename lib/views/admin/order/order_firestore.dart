import 'package:cloud_firestore/cloud_firestore.dart';

class OrderFsMethods {
  Future addOrders(Map<String, dynamic> orderInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Order")
        .doc()
        .set(orderInfoMap);
  }

  Future<DocumentSnapshot> getAddressCustomerDocument(
      String userUID, String addressCustomerId) async {
    return await FirebaseFirestore.instance
        .collection("Customer")
        .doc(userUID)
        .collection("AddressCustomer")
        .doc(addressCustomerId)
        .get();
  }

  Future<QuerySnapshot> getAllOrders() {
    return FirebaseFirestore.instance.collection("Order").get().then(
      (value) {
        return value;
      },
      onError: (error) {
        // Xử lý ngoại lệ nếu có
        print("Error fetching orders: $error");
        throw error; // Đẩy ngoại lệ lại sau khi xử lý
      },
    );
  }

  Future<void> updateOrder(
      String orderId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection("Order")
          .doc(orderId)
          .update(updatedData);
    } catch (e) {
      // Handle any errors that occur during the update
      print("Error updating order: $e");
      throw e; // Throw the error for handling in the calling code
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Order")
          .doc(orderId)
          .delete();
    } catch (e) {
      // Handle any errors that occur during the deletion
      print("Error deleting order: $e");
      throw e; // Throw the error for handling in the calling code
    }
  }
}
