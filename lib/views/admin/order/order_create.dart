import 'package:ecommerce_app_firebase/views/admin/order/order_firestore.dart';

import 'package:flutter/material.dart';

class OrderCreate extends StatefulWidget {
  const OrderCreate({Key? key}) : super(key: key);

  @override
  State<OrderCreate> createState() => _OrderCreateState();
}

class _OrderCreateState extends State<OrderCreate> {
  TextEditingController customerRefController = TextEditingController();
  TextEditingController employeeRefController = TextEditingController();
  TextEditingController order_date_timeController = TextEditingController();
  TextEditingController addressCustomerRefController = TextEditingController();
  TextEditingController shipping_costController = TextEditingController();
  TextEditingController total_priceController = TextEditingController();
  TextEditingController payment_method_nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create/Write Data"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Customer Name", customerRefController),
              _buildTextField("Employee", employeeRefController),
              _buildTextField("Order Date Time", order_date_timeController),
              _buildTextField("AddressCustomer", addressCustomerRefController),
              _buildTextField("Shipping Cost", shipping_costController),
              _buildTextField("Total Price", total_priceController),
              _buildTextField(
                  "Payment Method Name", payment_method_nameController),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _uploadData();
                },
                child: Text('Thêm'),
              ),
            ],
          ),
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
          decoration: InputDecoration(labelText: label),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  void _uploadData() async {
    try {
      if (1 == 1) {
        Map<String, dynamic> uploadData = {
          "customerRef": customerRefController.text,
          "employeeRef": employeeRefController.text,
          "order_date_time": order_date_timeController.text,
          "addressCustomerRef": addressCustomerRefController.text,
          "shipping_cost": shipping_costController.text,
          "total_price": total_priceController.text,
          "payment_method_name": payment_method_nameController.text,
        };

        await OrderFsMethods().addOrders(uploadData);
        Navigator.of(context).pushReplacementNamed('orderMain');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm Thành Công')),
        );
      }
    } catch (e) {
      print("Error uploading data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm dữ liệu. Vui lòng thử lại.')),
      );
    }
  }
}
