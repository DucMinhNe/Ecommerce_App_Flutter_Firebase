import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeFsMethods {
  Future addEmployees(Map<String, dynamic> employeeInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Employee")
        .doc()
        .set(employeeInfoMap);
  }

  Future<QuerySnapshot> getAllEmployees() {
    return FirebaseFirestore.instance.collection("Employee").get().then(
      (value) {
        return value;
      },
      onError: (error) {
        // Xử lý ngoại lệ nếu có
        print("Error fetching employees: $error");
        throw error; // Đẩy ngoại lệ lại sau khi xử lý
      },
    );
  }

  Future<void> updateEmployee(
      String employeeId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(employeeId)
          .update(updatedData);
    } catch (e) {
      // Handle any errors that occur during the update
      print("Error updating employee: $e");
      throw e; // Throw the error for handling in the calling code
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(employeeId)
          .delete();
    } catch (e) {
      // Handle any errors that occur during the deletion
      print("Error deleting employee: $e");
      throw e; // Throw the error for handling in the calling code
    }
  }
}
