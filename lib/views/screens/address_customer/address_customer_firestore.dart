import 'package:cloud_firestore/cloud_firestore.dart';

class AddressCustomerFsMethods {
  Future<QuerySnapshot> getAllAddressCustomersForCustomer(
      String userUID) async {
    return await FirebaseFirestore.instance
        .collection("Customer")
        .doc(userUID)
        .collection("AddressCustomer")
        .get();
  }

  Future addAddressForUser(
      String userUID, Map<String, dynamic> addressData) async {
    return await FirebaseFirestore.instance
        .collection("Customer") // Collection chứa thông tin của từng người dùng
        .doc(userUID) // Document của người dùng cụ thể
        .collection(
            "AddressCustomer") // Sub-collection lưu trữ địa chỉ giao hàng
        .add(addressData); // Thêm địa chỉ mới
  }

  Future updateAddressForUser(String userUID, String addressCustomerID,
      Map<String, dynamic> updatedData) async {
    return await FirebaseFirestore.instance
        .collection("Customer")
        .doc(userUID)
        .collection("AddressCustomer")
        .doc(addressCustomerID)
        .update(updatedData); // Cập nhật thông tin địa chỉ giao hàng
  }

  Future<void> deleteAddressForUser(
      String userUID, String addressCustomerID) async {
    return await FirebaseFirestore.instance
        .collection("Customer")
        .doc(userUID)
        .collection("AddressCustomer")
        .doc(addressCustomerID)
        .delete(); // Xóa địa chỉ giao hàng
  }
}
