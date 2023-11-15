import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final String productId;

  final Map<String, dynamic> productData;

  DetailPage({required this.productId, required this.productData});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _userUID = '';
  @override
  void initState() {
    _loadUserUID();
    super.initState();
  }

  Future<void> _loadUserUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userUID = prefs.getString('userUID') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (Get.isDarkMode)
          ? Colors.blue.shade200
          : const Color.fromARGB(255, 255, 254, 255),
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey,
            ),
          ),
        ),
        foregroundColor: (Get.isDarkMode)
            ? Colors.blue.shade200
            : Color.fromARGB(255, 2, 69, 255),
        backgroundColor: (Get.isDarkMode)
            ? Colors.blue.shade200
            : Color.fromARGB(255, 2, 69, 255),
        elevation: 0,
        bottomOpacity: 0.0,
        scrolledUnderElevation: 0,
        actions: [
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 26, top: 10, bottom: 10, right: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'CartScreen');
              },
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: 200,
                child:
                    Image.network(widget.productData['product_image'] ?? '')),
            Divider(
              thickness: 5,
              color: Color.fromARGB(255, 211, 214, 200),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        widget.productData['product_name'] ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 26),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            widget.productData['unit_price'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'đ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            children: const [
                              Text(
                                '⭐️⭐️⭐️⭐️⭐️',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 5,
              color: Color.fromARGB(255, 211, 214, 200),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Column(
                children: [
                  Text(
                    'Mô tả',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    widget.productData['description'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      wordSpacing: 1.4,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 5,
              color: Color.fromARGB(255, 211, 214, 200),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.red.shade500,
                  ),
                ),
                onPressed: () {
                  FirebaseFirestore.instance.collection('Cart').add({
                    'customerRef': _userUID,
                    'productRef': widget.productId,
                    'quantity': 1,
                    'unit_price': int.parse(widget.productData['unit_price']),
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm vào giỏ hàng thành công'),
                      ),
                    );
                  }).catchError((error) {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 140,
                  child: const Text(
                    'Thêm vào giỏ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 5,
              color: Color.fromARGB(255, 211, 214, 200),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bình luận',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Product')
                        .doc(widget.productId)
                        .collection('Comments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      var comments = snapshot.data?.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments?.length,
                        itemBuilder: (context, index) {
                          var comment = comments?[index];
                          return Container(
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Text(comment?['user']),
                                  title: Text(comment?['user']),
                                  subtitle: Text(comment?['text']),
                                  trailing: Text(
                                    '⭐️⭐️⭐️⭐️⭐️',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
