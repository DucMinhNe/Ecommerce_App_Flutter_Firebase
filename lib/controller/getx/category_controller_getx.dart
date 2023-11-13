import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app_firebase/models/getx/category_model_getx.dart';

class CategoryControllerGetx extends GetxController {
  CategoryModelGetx categoryModelGetx = CategoryModelGetx(i: 0);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchCategories() async {
    QuerySnapshot querySnapshot = await _firestore.collection('Product').get();
    List<String> categories = querySnapshot.docs
        .map((doc) => doc['product_category_name'] as String)
        .toList();
    return categories;
  }

  changeCategory({required int temp}) {
    categoryModelGetx.i = temp;
    update();
  }
}
