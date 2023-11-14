import 'package:ecommerce_app_firebase/views/screens/address_customer/address_customer_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressCustomerCreate extends StatefulWidget {
  const AddressCustomerCreate({Key? key}) : super(key: key);

  @override
  State<AddressCustomerCreate> createState() => _AddressCustomerCreateState();
}

class _AddressCustomerCreateState extends State<AddressCustomerCreate> {
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

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController subDistrictController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create/Write Data"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Name", nameController),
              _buildTextField("Address", addressController),
              _buildTextField("Phone Number", phoneNumberController),
              _buildTextField("City", cityController),
              _buildTextField("District", districtController),
              _buildTextField("Sub-district", subDistrictController),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _uploadData();
                },
                child: Text('Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Function to upload image to Firebase Storage

  void _uploadData() async {
    try {
      if (1 == 1) {
        Map<String, dynamic> uploadData = {
          "name": nameController.text,
          "phone_number": phoneNumberController.text,
          "city": cityController.text,
          "district": districtController.text,
          "sub_district": subDistrictController.text,
          "address": addressController.text,
        };

        await AddressCustomerFsMethods()
            .addAddressForUser(_userUID, uploadData);
        Navigator.of(context).pushReplacementNamed('addressCustomerMain');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm Thành Công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải ảnh lên. Vui lòng thử lại.')),
        );
      }
    } catch (e) {
      print("Error uploading data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm dữ liệu. Vui lòng thử lại.')),
      );
    }
  }
}
