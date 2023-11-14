import 'package:ecommerce_app_firebase/views/admin/customer/customer_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerMain extends StatefulWidget {
  @override
  _CustomerMainState createState() => _CustomerMainState();
}

class _CustomerMainState extends State<CustomerMain> {
  CustomerFsMethods customerFsMethods = CustomerFsMethods();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    customerFsMethods.getAllCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: customerFsMethods.getAllCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching customers'));
          } else {
            List<QueryDocumentSnapshot> customers = snapshot.data!.docs;

            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> customerData =
                    customers[index].data() as Map<String, dynamic>;
                String customerId = customers[index].id;

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            '${customerData['first_name']} ${customerData['last_name']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                    customerData['customer_image'] ?? ''),
                                SizedBox(height: 8),
                                Text(
                                  'Email: ${customerData['email'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Address: ${customerData['address'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Phone Number: ${customerData['phone_number'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Job Title: ${customerData['job_title_name'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Birth Date: ${customerData['birth_date'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Gender: ${customerData['gender'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Hire Date: ${customerData['hire_date'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Salary: ${customerData['salary'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Password: ${customerData['password'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Customer Category Name: ${customerData['customer_category_name'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Provider Name: ${customerData['provider_name'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                // Add other necessary information
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
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
                        width: 60,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          image: DecorationImage(
                            image: NetworkImage(
                                customerData['customer_image'] ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        '${customerData['first_name']} ${customerData['last_name']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(customerData['email'] ?? ''),
                          Text(
                            '$customerId',
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
                                'customerEdit',
                                arguments: {
                                  'customerId': customerId,
                                  'customerData': customerData,
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
                                      'Are you sure you want to delete this customer?',
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
                                            await CustomerFsMethods()
                                                .deleteCustomer(customerId);
                                            setState(() {
                                              customerFsMethods
                                                  .getAllCustomers();
                                            });
                                            Navigator.of(context).pop();
                                          } catch (e) {
                                            print(
                                                "Error deleting customer: $e");
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
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
          Navigator.of(context).pushNamed('customerCreate');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
