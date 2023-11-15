import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileFsMethods {
  Future<void> updateCustomer(
      String customerId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection("Customer")
          .doc(customerId)
          .update(updatedData);
    } catch (e) {
      print("Error updating customer: $e");
    }
  }
}
