import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/getx/category_controller_getx.dart';
import '../../models/resources.dart';
import '../components/drawer_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 33,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (Get.isDarkMode)
                        ? Colors.grey.shade600
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('CartScreen');
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 33,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (Get.isDarkMode)
                        ? Colors.grey.shade600
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () {
                      (Get.isDarkMode)
                          ? Get.changeThemeMode(ThemeMode.light)
                          : Get.changeThemeMode(ThemeMode.dark);
                    },
                    icon: const Icon(
                      Icons.sunny,
                      size: 18,
                      // color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
          centerTitle: false,
          title: Row(
            children: [
              Text(
                'Life Tech',
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
        body: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
                pauseAutoPlayOnManualNavigate: true,
                autoPlay: true,
                viewportFraction: 0.8,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              items: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade900,
                          blurRadius: 14,
                          offset: const Offset(2, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(40),
                      color: Color.fromARGB(255, 31, 37, 230),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Transform.scale(
                            scale: 1.2,
                            child: Image.asset(
                              'assets/images/stocks/1.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Thể Loại',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'category',
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: category
                            .map(
                              (e) => GetBuilder<CategoryControllerGetx>(
                                  builder: (categoryController) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(
                                          (categoryController
                                                      .categoryModelGetx.i ==
                                                  category.indexOf(e))
                                              ? 6
                                              : 0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        (categoryController
                                                    .categoryModelGetx.i ==
                                                category.indexOf(e))
                                            ? const Color.fromARGB(
                                                255, 54, 162, 244)
                                            : (Get.isDarkMode)
                                                ? Colors.grey.shade700
                                                : Colors.grey.shade200,
                                      ),
                                    ),
                                    onPressed: () {
                                      categoryController.changeCategory(
                                        temp: category.indexOf(e),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            e['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: (categoryController
                                                          .categoryModelGetx
                                                          .i ==
                                                      category.indexOf(e))
                                                  ? Colors.white
                                                  : (Get.isDarkMode)
                                                      ? Colors.white
                                                      : Colors.grey.shade800,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 30),
                    child: Row(
                      children: [
                        Text(
                          'Đang Phổ Biến',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            color: (Get.isDarkMode)
                                ? Colors.white
                                : Colors.grey.shade900,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('viewScreen');
                          },
                          child: Text(
                            'Xem Tất Cả ▶️',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.amber.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: GetBuilder<CategoryControllerGetx>(
                        builder: (categoryController) {
                      return Row(
                        children: AllProducts.map((e) {
                          int id = categoryController.categoryModelGetx.i + 1;
                          return (e.id == id)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 25, bottom: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          'DetailPage',
                                          arguments: e);
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      decoration: BoxDecoration(
                                          color: (Get.isDarkMode)
                                              ? Colors.grey.shade700
                                              : Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: (Get.isDarkMode)
                                                  ? Colors.grey.shade900
                                                  : Colors.grey.shade200,
                                              offset: const Offset(1, 2),
                                              blurRadius: 20,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 120,
                                            width: 200,
                                            child: Hero(
                                              tag: e.name,
                                              child: Image.asset(
                                                e.image,
                                                semanticLabel: e.name,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            e.name,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800,
                                              color: (Get.isDarkMode)
                                                  ? Colors.white
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 0,
                                          ),
                                          Text(
                                            e.category,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: (Get.isDarkMode)
                                                  ? Colors.white
                                                  : Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 0,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Text(
                                                  '℈',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: (Get.isDarkMode)
                                                        ? Colors.red.shade300
                                                        : Colors.red.shade700,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                e.price.toString(),
                                                style: TextStyle(
                                                  fontSize: 27,
                                                  fontWeight: FontWeight.w900,
                                                  color: (Get.isDarkMode)
                                                      ? Colors.white
                                                      : Colors.grey.shade800,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 14,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                );
                        }).toList(),
                      );
                    }),
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
