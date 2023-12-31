import 'package:ecommerce_app_firebase/models/getx/theme_getx_model.dart';
import 'package:ecommerce_app_firebase/views/admin/admin_main.dart';
import 'package:ecommerce_app_firebase/views/admin/customer/customer_create.dart';
import 'package:ecommerce_app_firebase/views/admin/customer/customer_edit.dart';
import 'package:ecommerce_app_firebase/views/admin/customer/customer_main.dart';
import 'package:ecommerce_app_firebase/views/admin/employee/employee_create.dart';
import 'package:ecommerce_app_firebase/views/admin/employee/employee_edit.dart';
import 'package:ecommerce_app_firebase/views/admin/employee/employee_main.dart';
import 'package:ecommerce_app_firebase/views/admin/order/order_create.dart';
import 'package:ecommerce_app_firebase/views/admin/order/order_edit.dart';
import 'package:ecommerce_app_firebase/views/admin/order/order_main.dart';
import 'package:ecommerce_app_firebase/views/admin/product/product_create.dart';
import 'package:ecommerce_app_firebase/views/admin/product/product_edit.dart';
import 'package:ecommerce_app_firebase/views/admin/product/product_main.dart';
import 'package:ecommerce_app_firebase/views/screens/address_customer/address_customer_create.dart';
import 'package:ecommerce_app_firebase/views/screens/address_customer/address_customer_edit.dart';
import 'package:ecommerce_app_firebase/views/screens/address_customer/address_customer_main.dart';
import 'package:ecommerce_app_firebase/views/screens/cart_screen.dart';
import 'package:ecommerce_app_firebase/views/screens/checkout_screen.dart';
import 'package:ecommerce_app_firebase/views/screens/detail_page.dart';
import 'package:ecommerce_app_firebase/views/screens/home_page.dart';
import 'package:ecommerce_app_firebase/views/screens/log_sign_page.dart';
import 'package:ecommerce_app_firebase/views/screens/order_placed/order_placed_edit.dart';
import 'package:ecommerce_app_firebase/views/screens/order_placed/order_placed_main.dart';
import 'package:ecommerce_app_firebase/views/screens/profile/profile_edit.dart';
import 'package:ecommerce_app_firebase/views/screens/sign_in_screen.dart';
import 'package:ecommerce_app_firebase/views/screens/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(myApp());
}

class myApp extends StatefulWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeModel.lightTheme,
      darkTheme: ThemeModel.darkTheme,
      initialRoute: 'logSignPage',
      routes: {
        'logSignPage': (context) => LogSignPage(),
        'signInScreen': (context) => SignInScreen(),
        'signUpScreen': (context) => SignUpScreen(),
        'homePage': (context) => HomePage(),
        // 'DetailPage': (context) => DetailPage(),
        'DetailPage': (context) {
          // Nhận đối tượng arguments từ đường dẫn
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          // Lấy productId từ đối tượng arguments
          final productId = arguments['productId'] ?? '';

          // Truyền productId và productData cho trang ProductEdit
          return DetailPage(
            productId: productId,
            productData: arguments['productData'] ?? {},
          );
        },
        'CartScreen': (context) => CartScreen(),
        'checkOutScreen': (context) => CheckOutScreen(),
        //admin
        'adminMain': (context) => AdminMain(),
        //Product
        'productCreate': (context) => ProductCreate(),
        'productEdit': (context) {
          // Nhận đối tượng arguments từ đường dẫn
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          // Lấy productId từ đối tượng arguments
          final productId = arguments['productId'] ?? '';

          // Truyền productId và productData cho trang ProductEdit
          return ProductEdit(
            productId: productId,
            productData: arguments['productData'] ?? {},
          );
        },
        'productMain': (context) => ProductMain(),
        //Employee
        'employeeCreate': (context) => EmployeeCreate(),
        'employeeEdit': (context) {
          // Nhận đối tượng arguments từ đường dẫn
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          // Lấy employeeId từ đối tượng arguments
          final employeeId = arguments['employeeId'] ?? '';

          // Truyền employeeId và employeeData cho trang EmployeeEdit
          return EmployeeEdit(
            employeeId: employeeId,
            employeeData: arguments['employeeData'] ?? {},
          );
        },
        'employeeMain': (context) => EmployeeMain(),

        //Customer   customer
        'customerCreate': (context) => CustomerCreate(),
        'customerEdit': (context) {
          // Nhận đối tượng arguments từ đường dẫn
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          // Lấy customerId từ đối tượng arguments
          final customerId = arguments['customerId'] ?? '';

          // Truyền customerId và customerData cho trang CustomerEdit
          return CustomerEdit(
            customerId: customerId,
            customerData: arguments['customerData'] ?? {},
          );
        },
        'customerMain': (context) => CustomerMain(),

        //addressCustomer
        'addressCustomerCreate': (context) => AddressCustomerCreate(),
        'addressCustomerEdit': (context) {
          // Nhận đối tượng arguments từ đường dẫn
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          // Lấy addressCustomerId từ đối tượng arguments
          final addressCustomerId = arguments['addressCustomerId'] ?? '';

          // Truyền addressCustomerId và addressCustomerData cho trang addressCustomerEdit
          return AddressCustomerEdit(
            addressCustomerId: addressCustomerId,
            addressCustomerData: arguments['addressCustomerData'] ?? {},
          );
        },
        'addressCustomerMain': (context) => AddressCustomerMain(),

        //order
        'orderCreate': (context) => OrderCreate(),
        'orderEdit': (context) {
          // Nhận đối tượng arguments từ đường dẫn
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          // Lấy orderId từ đối tượng arguments
          final orderId = arguments['orderId'] ?? '';

          // Truyền orderId và orderData cho trang orderEdit
          return OrderEdit(
            orderId: orderId,
            orderData: arguments['orderData'] ?? {},
          );
        },
        'orderMain': (context) => OrderMain(),

        'profileEdit': (context) {
          // Nhận đối tượng arguments từ đường dẫn
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          // Lấy customerId từ đối tượng arguments
          final customerId = arguments['customerId'] ?? '';

          // Truyền customerId và customerData cho trang CustomerEdit
          return ProfileEdit(
            customerId: customerId,
            customerData: arguments['customerData'] ?? {},
          );
        },

        'orderPlacedEdit': (context) {
          // Nhận đối tượng arguments từ đường dẫn
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;

          // Lấy orderId từ đối tượng arguments
          final orderId = arguments['orderId'] ?? '';

          // Truyền orderId và orderData cho trang orderEdit
          return OrderPlacedEdit(
            orderId: orderId,
            orderData: arguments['orderData'] ?? {},
          );
        },
        'orderPlacedMain': (context) => OrderPlacedMain(),
      },
    );
  }
}
