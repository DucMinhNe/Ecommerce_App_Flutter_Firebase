import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  String _userUID = '';
  String _selectedAddress = '';
  double _totalPrice = 0.0;
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
      floatingActionButton: FloatingActionButton.extended(
        icon: null,
        backgroundColor: Colors.red,
        onPressed: () {},
        label: const Text(
          'Xác Nhận',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Đặt Hàng',
          style: GoogleFonts.alata(
            fontSize: 30,
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
                fontSize: 30,
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

          Text(
            'Các Sản Phẩm',
            style: GoogleFonts.alata(
              fontSize: 15,
              fontWeight: FontWeight.bold,
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
                                    Text(cartData['quantity'].toString()),
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
              'Tổng Tiền: $_totalPrice',
              style: GoogleFonts.alata(
                fontSize: 30,
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
