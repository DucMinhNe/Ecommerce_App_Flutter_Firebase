import 'package:ecommerce_app_firebase/views/admin/product/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductMain extends StatefulWidget {
  @override
  _ProductMainState createState() => _ProductMainState();
}

class _ProductMainState extends State<ProductMain> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: databaseMethods.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching products'));
          } else {
            // Extract the list of products from the snapshot
            List<QueryDocumentSnapshot> products = snapshot.data!.docs;

            // Build the ListView with cards
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                // Get product data from the document
                Map<String, dynamic> productData =
                    products[index].data() as Map<String, dynamic>;

                // Create a Card for each product
                return Card(
                  child: ListTile(
                    title: Text(productData['product_name'] ?? ''),
                    subtitle: Text(productData['description'] ?? ''),
                    // Add more fields as needed

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to edit page
                            Navigator.of(context).pushNamed(
                              'productEdit',
                              arguments:
                                  productData, // Pass product data to edit page
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Show confirmation dialog before deleting
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text(
                                      'Are you sure you want to delete this product?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        try {
                                          // Delete the product and close the dialog
                                          await DatabaseMethods().deleteProduct(
                                              productData['productId']);
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        } catch (e) {
                                          // Handle errors
                                          print("Error deleting product: $e");
                                          // Show error message or take appropriate action
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
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('productCreate');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
