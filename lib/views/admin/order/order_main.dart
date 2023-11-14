import 'package:ecommerce_app_firebase/views/admin/order/order_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderMain extends StatefulWidget {
  @override
  _OrderMainState createState() => _OrderMainState();
}

class _OrderMainState extends State<OrderMain> {
  OrderFsMethods orderFsMethods = OrderFsMethods();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orderFsMethods.getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: orderFsMethods.getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching orders'));
          } else {
            // Extract the list of orders from the snapshot
            List<QueryDocumentSnapshot> orders = snapshot.data!.docs;

            // Build the ListView with cards
            // ...
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                // Get order data from the document
                Map<String, dynamic> orderData =
                    orders[index].data() as Map<String, dynamic>;

                // Get the document ID
                String orderId = orders[index].id;

                // Create a Card for each order
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            orderData['order_name'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Kích thước văn bản
                              color: Colors.blue, // Màu cho văn bản
                            ),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Customer Name: ${orderData['customerRef'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Employee: ${orderData['employeeRef'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Order Date Time: ${orderData['order_date_time'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Address Customer: ${orderData['addressCustomerRef'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Shipping Cost: ${orderData['shipping_cost'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Total Price: ${orderData['total_price'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Payment Method Name: ${orderData['payment_method_name'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              // Thêm các thông tin khác cần hiển thị
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.red, // Màu cho văn bản nút
                                  fontSize: 18, // Kích thước văn bản
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    elevation: 6,
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8),
                      leading: Text(
                        orderData['customerRef'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        orderData['order_date_time'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderData['total_price'] ?? ''),
                          Text(
                            '$orderId',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                'orderEdit',
                                arguments: {
                                  'orderId': orderId,
                                  'orderData': orderData,
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Delete'),
                                    content: Text(
                                      'Are you sure you want to delete this order?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            await OrderFsMethods()
                                                .deleteOrder(orderId);
                                            setState(() {
                                              // Refresh the orders after deletion
                                              orderFsMethods.getAllOrders();
                                            });
                                            Navigator.of(context).pop();
                                          } catch (e) {
                                            print("Error deleting order: $e");
                                          }
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
//
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
          Navigator.of(context).pushNamed('orderCreate');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}