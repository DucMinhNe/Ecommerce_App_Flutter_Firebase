import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: null,
        backgroundColor: Colors.red,
        onPressed: () {},
        label: const Text(
          'Đặt Hàng ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Giỏ Hàng',
          style: GoogleFonts.alata(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Cart').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                List<DocumentSnapshot> cartItems = snapshot.data!.docs;

                return ListView(
                  children: cartItems.map((DocumentSnapshot cartItem) {
                    final cartData = cartItem.data() as Map<String, dynamic>;
                    final productRef = cartData['productRef'];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Product')
                          .doc(productRef)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                        if (productSnapshot.connectionState ==
                            ConnectionState.done) {
                          if (productSnapshot.hasData &&
                              productSnapshot.data != null) {
                            final productData = productSnapshot.data!.data()
                                as Map<String, dynamic>;

                            return Card(
                              elevation: 6,
                              margin: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(8),
                                leading: Container(
                                  width: 60,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          productData['product_image'] ?? ''),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  productData['product_name'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${productData['description'] ?? ''}'),
                                    Text(
                                      '${cartData['price']}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        int updatedQuantity =
                                            cartData['quantity'] - 1;
                                        if (updatedQuantity > 0) {
                                          cartItem.reference.update(
                                              {'quantity': updatedQuantity});
                                        } else {
                                          // Nếu số lượng xuống 0, xóa sản phẩm khỏi giỏ hàng
                                          cartItem.reference.delete();
                                        }
                                      },
                                    ),
                                    Text(cartData['quantity'].toString()),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        int updatedQuantity =
                                            cartData['quantity'] + 1;
                                        cartItem.reference.update(
                                            {'quantity': updatedQuantity});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text('Product not found');
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
