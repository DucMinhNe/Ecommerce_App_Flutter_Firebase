import 'package:ecommerce_app_firebase/views/screens/address_customer/address_customer_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressCustomerMain extends StatefulWidget {
  @override
  _AddressCustomerMainState createState() => _AddressCustomerMainState();
}

class _AddressCustomerMainState extends State<AddressCustomerMain> {
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

  AddressCustomerFsMethods addressCustomerFsMethods =
      AddressCustomerFsMethods();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    addressCustomerFsMethods.getAllAddressCustomersForCustomer(_userUID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddressCustomer List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: addressCustomerFsMethods
            .getAllAddressCustomersForCustomer(_userUID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching AddressCustomers'));
          } else {
            // Extract the list of AddressCustomers from the snapshot
            List<QueryDocumentSnapshot> addressCustomers = snapshot.data!.docs;

            // Build the ListView with cards
            // ...
            return ListView.builder(
              itemCount: addressCustomers.length,
              itemBuilder: (context, index) {
                // Get addressCustomer data from the document
                Map<String, dynamic> addressCustomerData =
                    addressCustomers[index].data() as Map<String, dynamic>;

                // Get the document ID
                String addressCustomerId = addressCustomers[index].id;

                // Create a Card for each addressCustomer
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            addressCustomerData['name'] ?? '',
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
                              SizedBox(height: 8),
                              Text(
                                'Name: ${addressCustomerData['name'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Phone Number: ${addressCustomerData['phone_number'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'City: ${addressCustomerData['city'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'District: ${addressCustomerData['district'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              Text(
                                'Sub District: ${addressCustomerData['sub_district'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                ),
                              ),
                              // Text(
                              //   'Address: ${addressCustomerData['address'] ?? ''}',
                              //   style: TextStyle(
                              //     fontSize: 16, // Kích thước văn bản
                              //   ),
                              // ),
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
                      // leading: Text(
                      //   addressCustomerData['phone_number'] ?? '',
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      title: Text(
                        addressCustomerData['name'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(addressCustomerData['phone_number'] ?? ''),
                          Text(addressCustomerData['address'] ?? ''),
                          // Text(
                          //   '$addressCustomerId',
                          //   style: TextStyle(color: Colors.grey),
                          // ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                'addressCustomerEdit',
                                arguments: {
                                  'addressCustomerId': addressCustomerId,
                                  'addressCustomerData': addressCustomerData,
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
                                      'Are you sure you want to delete this addressCustomer?',
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
                                            await AddressCustomerFsMethods()
                                                .deleteAddressForUser(_userUID,
                                                    addressCustomerId);
                                            setState(() {
                                              // Refresh the addressCustomers after deletion
                                              addressCustomerFsMethods
                                                  .getAllAddressCustomersForCustomer(
                                                      _userUID);
                                            });
                                            Navigator.of(context).pop();
                                          } catch (e) {
                                            print(
                                                "Error deleting addressCustomer: $e");
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
          Navigator.of(context).pushNamed('addressCustomerCreate');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
