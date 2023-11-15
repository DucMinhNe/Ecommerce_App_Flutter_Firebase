import 'package:ecommerce_app_firebase/views/screens/order_placed/order_placed_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPlacedMain extends StatefulWidget {
  @override
  _OrderPlacedMainState createState() => _OrderPlacedMainState();
}

class _OrderPlacedMainState extends State<OrderPlacedMain> {
  OrderPlacedFsMethods orderPlacedFsMethods = OrderPlacedFsMethods();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orderPlacedFsMethods.getAllOrderPlaceds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrderPlaced List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: orderPlacedFsMethods.getAllOrderPlaceds(),
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
                    Navigator.of(context).pushNamed(
                      'orderEdit',
                      arguments: {
                        'orderId': orderId,
                        'orderData': orderData,
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
                          Text(orderData['total_price'].toString()),
                          Text(
                            '$orderId',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [],
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
