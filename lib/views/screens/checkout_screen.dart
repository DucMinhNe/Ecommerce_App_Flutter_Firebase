import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  String _userUID = '';
  String _selectedAddress = '';
  double _totalPrice = 0.0;
  double _shippingCost = 300.0;
  String _paymentMethod = 'COD';
  String _formattedDate = '';
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

  Future<String> getAddressCustomerId(String selectedAddress) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Customer')
        .doc(_userUID)
        .collection('AddressCustomer')
        .where('name', isEqualTo: selectedAddress)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // Lấy ID của tài liệu đầu tiên
    } else {
      return ''; // Trả về giá trị mặc định nếu không tìm thấy
    }
  }

  Future<void> _confirmOrder() async {
    try {
      // Tạo một map chứa thông tin đơn hàng
      String selectedAddressId = await getAddressCustomerId(_selectedAddress);
      Map<String, dynamic> orderData = {
        'customerRef': _userUID,
        'employeeRef': '',
        'order_date_time': _formattedDate,
        'addressCustomerRef': selectedAddressId,
        'shipping_cost': _shippingCost,
        'total_price': _totalPrice + _shippingCost,
        'payment_method_name': _paymentMethod,
        'status': 'Chờ Xử Lý',
      };

      // Thêm đơn hàng vào Firestore
      DocumentReference orderRef =
          await FirebaseFirestore.instance.collection('Order').add(orderData);

      // Lấy danh sách các Future khi thêm orderDetail
      List<Future<void>> orderDetailFutures = [];

      // Thêm chi tiết đơn hàng từ giỏ hàng
      await FirebaseFirestore.instance
          .collection('Cart')
          .where('customerRef', isEqualTo: _userUID)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          // Lấy thông tin từ giỏ hàng
          Map<String, dynamic> cartData = doc.data() as Map<String, dynamic>;
          String productRef = cartData['productRef'];
          double quantity =
              cartData['quantity'].toDouble(); // Chuyển đổi sang double
          double unitPrice =
              cartData['unit_price'].toDouble(); // Chuyển đổi sang double

          // Thêm Future cho việc thêm orderDetail
          orderDetailFutures.add(
            FirebaseFirestore.instance
                .collection('Order')
                .doc(orderRef.id)
                .collection('OrderDetail')
                .add({
              'quantity': quantity,
              'unit_price': unitPrice,
              'productRef': productRef,
            }),
          );
        });
      });

      // Chờ tất cả các Future hoàn thành
      await Future.wait(orderDetailFutures);

      // Xóa giỏ hàng sau khi đã đặt hàng
      await FirebaseFirestore.instance
          .collection('Cart')
          .where('customerRef', isEqualTo: _userUID)
          .get()
          .then((querySnapshot) async {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error confirming order: $e');
    }
  }

  // Future<void> _updateProductQuantity(
  //     String productRef, int quantityToReduce) async {
  //   try {
  //     // Lấy thông tin sản phẩm từ Firestore
  //     DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
  //         .collection('Product')
  //         .doc(productRef)
  //         .get();
  //     if (productSnapshot.exists) {
  //       // Giảm quantity trong sản phẩm
  //       int currentProductQuantity = productSnapshot['stock_quantity'];
  //       int updatedQuantity = currentProductQuantity - quantityToReduce;

  //       await FirebaseFirestore.instance
  //           .collection('Product')
  //           .doc(productRef)
  //           .update({
  //         'stock_quantity': updatedQuantity,
  //       });
  //     }
  //   } catch (e) {
  //     // Xử lý lỗi nếu có
  //     print('Error updating product quantity: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    _formattedDate = formattedDate;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: null,
        backgroundColor: Colors.red,
        onPressed: () async {
          _confirmOrder();
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Đặt Hàng Thành Công'),
                content: Text('Cảm ơn bạn đã đặt hàng!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Đóng popup
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          Navigator.pushReplacementNamed(context, 'homePage');
        },
        label: const Text(
          'Xác Nhận',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Đặt Hàng',
          style: GoogleFonts.alata(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Thông Tin Giao Hàng',
              style: GoogleFonts.alata(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // StreamBuilder để lấy danh sách địa chỉ từ Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Customer')
                .doc(_userUID)
                .collection('AddressCustomer')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> addressSnapshot) {
              if (addressSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (addressSnapshot.hasError) {
                return Text('Error: ${addressSnapshot.error}');
              } else if (!addressSnapshot.hasData ||
                  addressSnapshot.data!.docs.isEmpty) {
                return Text('Không có địa chỉ');
              } else {
                List<Map<String, dynamic>> addressList = addressSnapshot
                    .data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                String selectedAddressName = addressList.firstWhere(
                  (address) => address['name'] == _selectedAddress,
                  orElse: () => {'name': ''},
                )['name'];

                return Card(
                  elevation: 6,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      selectedAddressName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: _selectedAddress.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addressList.firstWhere(
                                      (address) =>
                                          address['name'] == _selectedAddress,
                                      orElse: () => {'phone_number': ''},
                                    )['phone_number'] ??
                                    '',
                              ),
                              Text(
                                addressList.firstWhere(
                                      (address) =>
                                          address['name'] == _selectedAddress,
                                      orElse: () => {'address': ''},
                                    )['address'] ??
                                    '',
                              ),
                            ],
                          )
                        : Text('Chưa chọn địa chỉ'),
                    onTap: () {
                      _showAddressSelectionDialog(context, addressList);
                    },
                  ),
                );
              }
            },
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Các Sản Phẩm',
              style: GoogleFonts.alata(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Cart')
                  .where('customerRef', isEqualTo: _userUID)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                List<DocumentSnapshot> cartItems = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cartData =
                        cartItems[index].data() as Map<String, dynamic>;
                    final productRef = cartData['productRef'];
                    _totalPrice = 0;
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
                            _totalPrice +=
                                cartData['unit_price'] * cartData['quantity'];
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
                                      'Giá: ${cartData['unit_price'] * cartData['quantity']}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      cartData['quantity'].toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text('Product not found');
                          }
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Thời Gian Đặt Hàng:\n$formattedDate',
              style: GoogleFonts.alata(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Hình Thức Thanh Toán: $_paymentMethod',
              style: GoogleFonts.alata(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tiền Ship: $_shippingCost',
              style: GoogleFonts.alata(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tổng Tiền: ${_totalPrice + _shippingCost}',
              style: GoogleFonts.alata(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị hộp thoại chọn địa chỉ
  void _showAddressSelectionDialog(
      BuildContext context, List<Map<String, dynamic>> addressList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn Địa Chỉ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: addressList.map((address) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAddress = address['name'];
                    });
                    Navigator.of(context).pop();
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(address['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(address['phone_number'] ?? ''),
                          Text(address['address'] ?? ''),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
