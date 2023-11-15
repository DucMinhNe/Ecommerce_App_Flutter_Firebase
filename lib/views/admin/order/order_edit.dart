import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/views/admin/order/order_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderEdit extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  OrderEdit({required this.orderId, required this.orderData});

  @override
  _OrderEditState createState() => _OrderEditState();
}

class _OrderEditState extends State<OrderEdit> {
  OrderFsMethods orderFsMethods = OrderFsMethods();
  Map<String, dynamic> _addressCustomerData = {};
  late TextEditingController _customerRefController;
  late TextEditingController _employeeRefController;
  late TextEditingController _orderDateTimeController;
  late TextEditingController _addressCustomerRefController;
  late TextEditingController _shippingCostController;
  late TextEditingController _totalPriceController;
  late TextEditingController _paymentMethodNameController;
  late TextEditingController _statusController;

  late TextEditingController _addressCustomerNameController;
  late TextEditingController _addressCustomerPhoneNumberController;

  bool _isUpdating = false;
  String _userUID = '';
  Future<void> _loadUserUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userUID = prefs.getString('userUID') ?? '';
    });
  }

  @override
  void initState() {
    _loadUserUID();

    super.initState();

    // Set initial values for controllers
    _customerRefController =
        TextEditingController(text: widget.orderData['customerRef'] ?? '');
    _employeeRefController =
        TextEditingController(text: widget.orderData['employeeRef'] ?? '');
    _orderDateTimeController =
        TextEditingController(text: widget.orderData['order_date_time'] ?? '');
    _addressCustomerRefController = TextEditingController(
        text: widget.orderData['addressCustomerRef'] ?? '');
    _shippingCostController = TextEditingController(
        text: widget.orderData['shipping_cost']?.toString() ?? '');
    _totalPriceController = TextEditingController(
        text: widget.orderData['total_price']?.toString() ?? '');
    _paymentMethodNameController = TextEditingController(
        text: widget.orderData['payment_method_name'] ?? '');
    _statusController =
        TextEditingController(text: widget.orderData['status'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Order'),
      ),
      body: _isUpdating ? _buildLoadingIndicator() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order ID: ${widget.orderId}'),
          SizedBox(height: 16),
          _buildTextField('Customer UID', _customerRefController),
          _buildTextField('Employee UID', _employeeRefController),
          _buildTextField('Order Date Time', _orderDateTimeController),
          _buildTextField(
              'Address Customer UID', _addressCustomerRefController),
          _buildTextField('Shipping Cost', _shippingCostController),
          _buildTextField('Total Price', _totalPriceController),
          _buildTextField('Payment Method Name', _paymentMethodNameController),
          _buildTextField('Status', _statusController),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isUpdating ? null : _updateOrder,
            child: Text('Save Changes'),
          ),
        ],
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
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _updateOrder() async {
    setState(() {
      _isUpdating = true;
    });

    // Get the updated data from controllers
    String updatedCustomerRef = _customerRefController.text.trim();
    String updatedEmployeeRef = _employeeRefController.text.trim();
    String updatedOrderDateTime = _orderDateTimeController.text.trim();
    String updatedAddressCustomerRef =
        _addressCustomerRefController.text.trim();
    double updatedShippingCost =
        double.parse(_shippingCostController.text.trim());
    double updatedTotalPrice = double.parse(_totalPriceController.text.trim());
    String updatedPaymentMethodName = _paymentMethodNameController.text.trim();
    String updatedStatus = _statusController.text.trim();

    // Create a map with updated data
    Map<String, dynamic> updatedData = {
      'customerRef': updatedCustomerRef,
      'employeeRef': updatedEmployeeRef,
      'order_date_time': updatedOrderDateTime,
      'addressCustomerRef': updatedAddressCustomerRef,
      'shipping_cost': updatedShippingCost,
      'total_price': updatedTotalPrice,
      'payment_method_name': updatedPaymentMethodName,
      'status': updatedStatus,
      // Add other fields as needed
    };

    // Call the updateOrder function from your OrderFsMethods class
    try {
      await OrderFsMethods().updateOrder(widget.orderId, updatedData);
      Navigator.of(context).pushReplacementNamed('orderMain');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order updated successfully'),
        ),
      );
    } catch (e) {
      print("Error updating order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating order. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }
}
