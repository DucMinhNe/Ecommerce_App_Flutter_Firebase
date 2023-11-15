import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPlacedFsMethods {
  Future<QuerySnapshot> getAllOrderPlaceds() {
    return FirebaseFirestore.instance.collection("Order").get().then(
      (value) {
        return value;
      },
      onError: (error) {
        print("Error fetching orders: $error");
        throw error;
      },
    );
  }

  Future<void> updateOrderPlaced(
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
}
