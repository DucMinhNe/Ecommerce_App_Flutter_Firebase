import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/views/admin/order/order_firestore.dart';
import 'package:flutter/material.dart';

class OrderEdit extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  OrderEdit({required this.orderId, required this.orderData});

  @override
  _OrderEditState createState() => _OrderEditState();
}

class _OrderEditState extends State<OrderEdit> {
  OrderFsMethods orderFsMethods = OrderFsMethods();

  late TextEditingController _customerRefController;
  late TextEditingController _employeeRefController;
  late TextEditingController _orderDateTimeController;
  late TextEditingController _addressCustomerRefController;
  late TextEditingController _shippingCostController;
  late TextEditingController _totalPriceController;
  late TextEditingController _paymentMethodNameController;
  late TextEditingController _statusController;

  bool _isUpdating = false;

  Future<Map<String, dynamic>> getCustomerData(String customerRef) async {
    DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection("Customer")
        .doc(customerRef)
        .get();

    if (customerSnapshot.exists) {
      return customerSnapshot.data() as Map<String, dynamic>;
    } else {
      return {}; // hoặc có thể trả về một giá trị mặc định khác tùy thuộc vào yêu cầu của bạn
    }
  }

  Future<Map<String, dynamic>> getAddressCustomerData(
      String addressCustomerRef) async {
    DocumentSnapshot addressCustomerSnapshot = await FirebaseFirestore.instance
        .collection("Customer")
        .doc(widget.orderData['customerRef'])
        .collection('AddressCustomer')
        .doc(addressCustomerRef)
        .get();

    if (addressCustomerSnapshot.exists) {
      return addressCustomerSnapshot.data() as Map<String, dynamic>;
    } else {
      return {}; // hoặc có thể trả về một giá trị mặc định khác tùy thuộc vào yêu cầu của bạn
    }
  }

  @override
  void initState() {
    super.initState();
    // _customerRefController =
    //     TextEditingController(text: widget.orderData['customerRef'] ?? '');
    // _employeeRefController =
    //     TextEditingController(text: widget.orderData['employeeRef'] ?? '');
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
        title: Text('Chi Tiết Đơn Hàng Admin'),
      ),
      body: _isUpdating ? _buildLoadingIndicator() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${widget.orderId}'),
            SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: getCustomerData(widget.orderData['customerRef']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error fetching customer data');
                } else {
                  Map<String, dynamic> customerData = snapshot.data ?? {};

                  return Column(
                    children: [
                      _buildTextField(
                          'First Name',
                          TextEditingController(
                              text: customerData['first_name'] ?? '')),
                      _buildTextField(
                          'Last Name',
                          TextEditingController(
                              text: customerData['last_name'] ?? '')),
                      _buildTextField(
                          'Email',
                          TextEditingController(
                              text: customerData['email'] ?? '')),
                    ],
                  );
                }
              },
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: getAddressCustomerData(
                  widget.orderData['addressCustomerRef']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error fetching customer data');
                } else {
                  Map<String, dynamic> addressCustomerData =
                      snapshot.data ?? {};

                  return Column(
                    children: [
                      Text('Thông Tin Giao Hàng'),
                      _buildTextField(
                          'Name',
                          TextEditingController(
                              text: addressCustomerData['name'] ?? '')),
                      _buildTextField(
                          'Phone Number',
                          TextEditingController(
                              text: addressCustomerData['phone_number'] ?? '')),
                      _buildTextField(
                          'Address',
                          TextEditingController(
                              text: addressCustomerData['address'] ?? '')),
                    ],
                  );
                }
              },
            ),
            // _buildTextField('Employee UID', _employeeRefController),
            _buildTextField('Order Date Time', _orderDateTimeController),
            _buildTextField('Shipping Cost', _shippingCostController),

            _buildTextField(
                'Payment Method Name', _paymentMethodNameController),
            _buildTextField('Status', _statusController),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateOrder("Đang Giao Hàng");
                  },
                  child: Text('Đang Giao Hàng'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _updateOrder("Đã Giao Hàng");
                  },
                  child: Text('Đã Giao Hàng'),
                ),
              ],
            ),
            Text('Sản Phẩm'),
            Container(
              height: 200,
              child: Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Order")
                      .doc(widget.orderId)
                      .collection('OrderDetail')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error fetching orders'));
                    } else {
                      QuerySnapshot orderDetailsSnapshot = snapshot.data!;

                      if (orderDetailsSnapshot.docs.isEmpty) {
                        return Center(child: Text('No orders found'));
                      }

                      return ListView.builder(
                        itemCount: orderDetailsSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot orderDetailDocument =
                              orderDetailsSnapshot.docs[index];
                          Map<String, dynamic> orderDetailData =
                              orderDetailDocument.data()
                                  as Map<String, dynamic>;

                          // Fetch associated product details
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('Product')
                                .doc(orderDetailData['productRef'])
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot>
                                    productSnapshot) {
                              if (productSnapshot.connectionState ==
                                  ConnectionState.done) {
                                if (productSnapshot.hasData &&
                                    productSnapshot.data != null) {
                                  final productData = productSnapshot.data!
                                      .data() as Map<String, dynamic>;

                                  return ListTile(
                                    contentPadding: EdgeInsets.all(8),
                                    leading: Container(
                                      width: 50,
                                      height: 100,
                                      child: Image.network(
                                          productData['product_image'] ?? ''),
                                    ),
                                    title: Text(
                                      productData['product_name'] ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      orderDetailData['unit_price'].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Text(
                                      orderDetailData['quantity'].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                } else {
                                  return Text('Product not found');
                                }
                              } else {
                                return Container(
                                  width: 500.0,
                                  height: 120.0,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    value: 1,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            _buildTextField('Total Price', _totalPriceController),
            ElevatedButton(
              onPressed: () {},
              child: Text('Save Changes'),
            ),
          ],
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

  void _updateOrder(String updatedStatus) async {
    setState(() {
      _isUpdating = true;
    });

    // Create a map with updated data
    Map<String, dynamic> updatedData = {
      // 'status': "Đã Giao Hàng",
      'status': updatedStatus,
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
