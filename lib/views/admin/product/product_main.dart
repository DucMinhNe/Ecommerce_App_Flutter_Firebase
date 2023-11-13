import 'package:ecommerce_app_firebase/views/admin/product/product_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductMain extends StatefulWidget {
  @override
  _ProductMainState createState() => _ProductMainState();
}

class _ProductMainState extends State<ProductMain> {
  ProductFsMethods productFsMethods = ProductFsMethods();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productFsMethods.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: productFsMethods.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching products'));
          } else {
            // Extract the list of products from the snapshot
            List<QueryDocumentSnapshot> products = snapshot.data!.docs;

            // Build the ListView with cards
            // ...
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                // Get product data from the document
                Map<String, dynamic> productData =
                    products[index].data() as Map<String, dynamic>;

                // Get the document ID
                String productId = products[index].id;

                // Create a Card for each product
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            productData['product_name'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Kích thước văn bản
                              color: Colors.blue, // Màu cho văn bản
                            ),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(productData['product_image'] ?? ''),
                              SizedBox(height: 8),
                              Text(
                                'Description: ${productData['description'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Unit Price: ${productData['unit_price'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Stock Quantity: ${productData['stock_quantity'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Product Category Name: ${productData['product_category_name'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Provider Name: ${productData['provider_name'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              // Thêm các thông tin khác cần hiển thị
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.red, // Màu cho văn bản nút
                                  fontSize: 18, // Kích thước văn bản
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    elevation: 6,
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8),
                      leading: Container(
                        width: 60, // Độ rộng mong muốn của hình chữ nhật
                        height: 70, // Độ cao mong muốn của hình chữ nhật
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
                          Text(productData['description'] ?? ''),
                          Text(
                            '$productId',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                'productEdit',
                                arguments: {
                                  'productId': productId,
                                  'productData': productData,
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Delete'),
                                    content: Text(
                                      'Are you sure you want to delete this product?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            await ProductFsMethods()
                                                .deleteProduct(productId);
                                            setState(() {
                                              // Refresh the products after deletion
                                              productFsMethods.getAllProducts();
                                            });
                                            Navigator.of(context).pop();
                                          } catch (e) {
                                            print("Error deleting product: $e");
                                          }
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
//
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
          Navigator.of(context).pushNamed('productCreate');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
