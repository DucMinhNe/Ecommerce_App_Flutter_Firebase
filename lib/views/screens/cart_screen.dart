<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controller/helper_classes/firebase_firestore_helper.dart';
=======
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';
>>>>>>> main

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
<<<<<<< HEAD
            flex: 9,
            child: StreamBuilder(
              stream: FireBaseStoreHelper.db.collection("Cart").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                } else if (snapshot.hasData) {
                  QuerySnapshot<Map<String, dynamic>>? favourite =
                      snapshot.data;
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> allFav =
                      favourite!.docs;
                  if (allFav.isNotEmpty) {
                    int sum = 0;
                    int qut = 0;
                    allFav.forEach((e) {
                      qut = e['quantity'] + qut;
                      int psum = e['quantity'] * e['price'];
                      sum = sum + psum;
                    });
                    return Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: ListView.builder(
                              itemCount: allFav.length,
                              padding: const EdgeInsets.all(20),
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: (Get.isDarkMode)
                                                ? Colors.grey.shade900
                                                : Colors.grey.shade300,
                                            offset: const Offset(1, 2),
                                            blurRadius: 8)
                                      ],
                                      borderRadius: BorderRadius.circular(30),
                                      color: (Get.isDarkMode)
                                          ? Colors.grey.shade800
                                          : Colors.white,
                                    ),
                                    height: 140,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: ListTile(
                                      leading: Transform.scale(
                                        scale: 1.6,
                                        child: Hero(
                                          tag: allFav[i]['quantity'],
                                          child: Transform.translate(
                                            offset: const Offset(3, 10),
                                            child: Image.asset(
                                              allFav[i]['quantity'],
                                            ),
                                          ),
                                        ),
                                      ),
                                      isThreeLine: true,
                                      title: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 8.0),
                                        child: Text(
                                          allFav[i]['quantity'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            width: 50,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Colors.red.shade500,
                                                ),
                                              ),
                                              onPressed: () {
                                                Provider.of<CartController>(
                                                        context,
                                                        listen: false)
                                                    .deleteFromCart(
                                                        Uid: allFav[i]
                                                            ['quantity']);
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '℈${allFav[i]['price']}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 10),
                                                child: Text(
                                                  allFav[i]['quantity'],
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 2,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(
                                                color: Colors.grey,
                                                onPressed: () {
                                                  Provider.of<CartController>(
                                                    context,
                                                    listen: false,
                                                  ).decrement(e: allFav[i]);
                                                },
                                                icon: const Icon(
                                                  Icons.remove,
                                                  size: 25,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey.shade400,
                                                ),
                                                child: Text(
                                                  '${allFav[i]['quantity']}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                color: Colors.grey,
                                                onPressed: () {
                                                  Provider.of<CartController>(
                                                    context,
                                                    listen: false,
                                                  ).increment(e: allFav[i]);
                                                },
                                                icon: const Icon(
                                                  Icons.add,
                                                  size: 25,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 160 - 76,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 3),
                                  child: Text(
                                    'Total Amount : $sum',
                                    style: GoogleFonts.alata(
                                      letterSpacing: 1,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8),
                                  child: Text(
                                    'Total Amount : $qut',
                                    style: GoogleFonts.alata(
                                      letterSpacing: 1,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Icon(
                        Icons.add_shopping_cart,
                        size: 300,
                        color: Colors.grey.shade300,
                      ),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
=======
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
>>>>>>> main
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
