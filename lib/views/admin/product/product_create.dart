import './database.dart';
import 'package:flutter/material.dart';

class ProductCreate extends StatefulWidget {
  const ProductCreate({super.key});

  @override
  State<ProductCreate> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreate> {
  uploadData() async {
    Map<String, dynamic> uploaddata = {
      "product_name": product_namecontroller.text,
      "description": descriptioncontroller.text,
      "unit_price": unit_pricecontroller.text,
      "stock_quantity": stock_quantitycontroller.text,
      "product_image": product_imagecontroller.text,
      "product_category_name": product_category_namecontroller.text,
      "provider_name": provider_namecontroller.text,
    };

    await DatabaseMethods().addProducts(uploaddata);
    final snackBar = SnackBar(content: Text('Thêm Thành Công'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  TextEditingController product_namecontroller = new TextEditingController();
  TextEditingController descriptioncontroller = new TextEditingController();
  TextEditingController unit_pricecontroller = new TextEditingController();
  TextEditingController stock_quantitycontroller = new TextEditingController();
  TextEditingController product_imagecontroller = new TextEditingController();
  TextEditingController product_category_namecontroller =
      new TextEditingController();
  TextEditingController provider_namecontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create/Write Data"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Product Name",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Color(0xFF4c59a5),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: product_namecontroller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(color: Colors.white60)),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Description",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  color: Color(0xFF4c59a5),
                  borderRadius: BorderRadius.circular(22)),
              child: TextField(
                controller: descriptioncontroller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(color: Colors.white60)),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Unit Price",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  color: Color(0xFF4c59a5),
                  borderRadius: BorderRadius.circular(22)),
              child: TextField(
                controller: unit_pricecontroller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(color: Colors.white60)),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Stock Quantity",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  color: Color(0xFF4c59a5),
                  borderRadius: BorderRadius.circular(22)),
              child: TextField(
                controller: stock_quantitycontroller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(color: Colors.white60)),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Product Image",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  color: Color(0xFF4c59a5),
                  borderRadius: BorderRadius.circular(22)),
              child: TextField(
                controller: product_imagecontroller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(color: Colors.white60)),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Product Category Name",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  color: Color(0xFF4c59a5),
                  borderRadius: BorderRadius.circular(22)),
              child: TextField(
                controller: product_category_namecontroller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(color: Colors.white60)),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Provider Name",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  color: Color(0xFF4c59a5),
                  borderRadius: BorderRadius.circular(22)),
              child: TextField(
                controller: provider_namecontroller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(color: Colors.white60)),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                uploadData();
              },
              child: Center(
                child: Container(
                  width: 150,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "Thêm",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
