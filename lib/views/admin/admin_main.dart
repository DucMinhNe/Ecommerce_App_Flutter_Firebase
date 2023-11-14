import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../controller/getx/category_controller_getx.dart';
import '../components/drawer_component.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({Key? key}) : super(key: key);

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  int i = 0;
  CategoryControllerGetx categoryControllerGetx =
      Get.put(CategoryControllerGetx());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return true to allow back navigation, or false to prevent it
        return false;
      },
      child: Scaffold(
        drawer: const drawerComponent(),
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: Row(
            children: [
              Text(
                'ADMIN',
                style: GoogleFonts.lobster(
                  color: (Get.isDarkMode)
                      ? Colors.blue.shade200
                      : Colors.blue.shade800,
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 4,
                        color: Colors.blue,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('customerMain');
                          },
                          child: Container(
                            height: 100,
                            child: ListTile(
                              leading: Icon(Icons.person,
                                  color: Colors.white), // Hình ảnh người dùng
                              title: Text(
                                'Người Dùng',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        color: Colors.green,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('productMain');
                          },
                          child: Container(
                            height: 100,
                            child: ListTile(
                              leading: Icon(Icons.shopping_cart,
                                  color: Colors.white), // Hình ảnh giỏ hàng
                              title: Text(
                                'Sản Phẩm',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 4,
                        color: Colors.green,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('employeeMain');
                          },
                          child: Container(
                            height: 100,
                            child: ListTile(
                              leading: Icon(Icons.work,
                                  color: Colors.white), // Hình ảnh nhân viên
                              title: Text(
                                'Nhân Viên',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        color: Colors.blue,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('orderMain');
                          },
                          child: Container(
                            height: 100,
                            child: ListTile(
                              leading: Icon(Icons.assignment,
                                  color: Colors.white), // Hình ảnh đơn hàng
                              title: Text(
                                'Đơn đặt hàng',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
