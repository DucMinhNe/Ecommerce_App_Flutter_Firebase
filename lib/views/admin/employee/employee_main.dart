import 'package:ecommerce_app_firebase/views/admin/employee/employee_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeMain extends StatefulWidget {
  @override
  _EmployeeMainState createState() => _EmployeeMainState();
}

class _EmployeeMainState extends State<EmployeeMain> {
  EmployeeFsMethods employeeFsMethods = EmployeeFsMethods();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    employeeFsMethods.getAllEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: employeeFsMethods.getAllEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching employees'));
          } else {
            List<QueryDocumentSnapshot> employees = snapshot.data!.docs;

            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> employeeData =
                    employees[index].data() as Map<String, dynamic>;
                String employeeId = employees[index].id;

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            '${employeeData['first_name']} ${employeeData['last_name']}' ??
                                '',
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
                                    employeeData['employee_image'] ?? ''),
                                SizedBox(height: 8),
                                Text(
                                  'Email: ${employeeData['email'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Address: ${employeeData['address'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Phone Number: ${employeeData['phone_number'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Job Title: ${employeeData['job_title_name'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Birth Date: ${employeeData['birth_date'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Gender: ${employeeData['gender'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Hire Date: ${employeeData['hire_date'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Salary: ${employeeData['salary'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Password: ${employeeData['password'] ?? ''}',
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
                                employeeData['employee_image'] ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        '${employeeData['first_name']} ${employeeData['last_name']}' ??
                            '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employeeData['email'] ?? ''),
                          Text(
                            '$employeeId',
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
                                'employeeEdit',
                                arguments: {
                                  'employeeId': employeeId,
                                  'employeeData': employeeData,
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
                                      'Are you sure you want to delete this employee?',
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
                                            await EmployeeFsMethods()
                                                .deleteEmployee(employeeId);
                                            setState(() {
                                              employeeFsMethods
                                                  .getAllEmployees();
                                            });
                                            Navigator.of(context).pop();
                                          } catch (e) {
                                            print(
                                                "Error deleting employee: $e");
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
          Navigator.of(context).pushNamed('employeeCreate');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
