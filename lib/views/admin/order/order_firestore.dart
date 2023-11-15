import 'package:cloud_firestore/cloud_firestore.dart';

class OrderFsMethods {
  Future addOrders(Map<String, dynamic> orderInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Order")
        .doc()
        .set(orderInfoMap);
  }

  Future<DocumentSnapshot> getCustomerByCustomerRef(String customerRef) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Customer")
          .doc(customerRef)
          .get();

      return documentSnapshot;
    } catch (error) {
      print("Error fetching orders by customerRef: $error");
      throw error; // Throw the error for handling in the calling code
    }
  }

  Future<DocumentSnapshot> getAddressCustomerByAddressCustomerRef(
      String customerRef, String addressCustomerRef) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Customer")
          .doc(customerRef)
          .collection("AddressCustomer")
          .doc(addressCustomerRef)
          .get();

      return documentSnapshot;
    } catch (error) {
      print("Error fetching orders by customerRef: $error");
      throw error; // Throw the error for handling in the calling code
    }
  }

  Future<DocumentSnapshot> getEmployeeByEmployeeRef(String employeeRef) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(employeeRef)
          .get();

      return documentSnapshot;
    } catch (error) {
      print("Error fetching orders by customerRef: $error");
      throw error; // Throw the error for handling in the calling code
    }
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
