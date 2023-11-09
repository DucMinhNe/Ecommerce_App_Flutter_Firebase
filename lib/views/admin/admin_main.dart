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
                        color: Colors.blue, // Màu cho Card 1
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap for Card 1
                            print('Card 1 tapped');
                          },
                          child: Container(
                            height: 100, // Đặt chiều cao mong muốn
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  'Người Dùng',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white), // Màu cho văn bản
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Khoảng cách giữa các thẻ
                    Expanded(
                      child: Card(
                        color: Colors.green, // Màu cho Card 2
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('ProductMain');
                          },
                          child: Container(
                            height: 100, // Đặt chiều cao mong muốn
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  'Sản Phẩm',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white), // Màu cho văn bản
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
                        color: Colors.green, // Màu cho Card 1
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap for Card 1
                            print('Card 1 tapped');
                          },
                          child: Container(
                            height: 100, // Đặt chiều cao mong muốn
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  'Nhân Viên',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white), // Màu cho văn bản
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Khoảng cách giữa các thẻ
                    Expanded(
                      child: Card(
                        color: Colors.blue, // Màu cho Card 2
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap for Card 2
                            print('Card 2 tapped');
                          },
                          child: Container(
                            height: 100, // Đặt chiều cao mong muốn
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  'Đơn đặt hàng',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white), // Màu cho văn bản
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
