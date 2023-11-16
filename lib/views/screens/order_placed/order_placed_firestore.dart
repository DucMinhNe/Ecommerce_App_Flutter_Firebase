import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPlacedFsMethods {
  Future<QuerySnapshot> getAllOrders(String customerRef) {
    return FirebaseFirestore.instance
        .collection("Order")
        .where('customerRef', isEqualTo: customerRef)
        .get()
        .then(
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
}
