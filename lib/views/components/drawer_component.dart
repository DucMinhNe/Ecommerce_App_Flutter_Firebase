import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class drawerComponent extends StatefulWidget {
  const drawerComponent({Key? key}) : super(key: key);

  @override
  State<drawerComponent> createState() => _drawerComponentState();
}

class _drawerComponentState extends State<drawerComponent> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
    ;
    return Drawer(
      child: Builder(builder: (context) {
        return Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: Color.fromARGB(255, 19, 61, 138),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Customer")
                            .doc(_userUID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // or any other loading widget
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            var userData = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    // ... Your avatar setup
                                    ),
                                Text(
                                  userData?['first_name'] +
                                      ' ' +
                                      userData?['last_name'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  userData?['email'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                // Display other user info as needed
                              ],
                            );
                          }
                          return Text('No user data');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 10,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('homePage');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.person),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Trang Mua Hàng',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('adminMain');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.person),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Trang Admin',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.person),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Thông tin',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.settings),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Cài Đặt',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('addressCustomerMain');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.contact_mail),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Sổ Địa Chỉ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('CartScreen');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.shopping_cart),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Giỏ Hàng',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.help),
                              SizedBox(width: 20),
                              Text(
                                'Trợ Giúp',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await firebaseAuth.signOut();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove(
                              'userUID'); // Xóa thông tin userUID khi đăng xuất
                          Navigator.pushReplacementNamed(
                              context, 'logSignPage');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.logout),
                              SizedBox(width: 20),
                              Text(
                                'Đăng Xuất',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        );
      }),
    );
  }
}
