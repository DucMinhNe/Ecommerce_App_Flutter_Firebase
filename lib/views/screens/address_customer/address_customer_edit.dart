import 'package:ecommerce_app_firebase/views/screens/address_customer/address_customer_firestore.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddressCustomerEdit extends StatefulWidget {
  final String addressCustomerId;
  final Map<String, dynamic> addressCustomerData;

  AddressCustomerEdit(
      {required this.addressCustomerId, required this.addressCustomerData});

  @override
  _AddressCustomerEditState createState() => _AddressCustomerEditState();
}

class _AddressCustomerEditState extends State<AddressCustomerEdit> {
  String _userUID = '';
  @override
  void initState() {
    _loadUserUID();
    _nameController =
        TextEditingController(text: widget.addressCustomerData['name'] ?? '');
    _phoneNumberController = TextEditingController(
        text: widget.addressCustomerData['phone_number'] ?? '');
    _cityController = TextEditingController(
        text: widget.addressCustomerData['city']?.toString() ?? '');
    _districtController = TextEditingController(
        text: widget.addressCustomerData['district']?.toString() ?? '');

    _subDistrictController = TextEditingController(
        text: widget.addressCustomerData['sub_district'] ?? '');
    _addressController = TextEditingController(
        text: widget.addressCustomerData['address'] ?? '');
    super.initState();
  }

  Future<void> _loadUserUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userUID = prefs.getString('userUID') ?? '';
    });
  }

  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _subDistrictController;
  late TextEditingController _addressController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Address Customer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AddressCustomer ID: ${widget.addressCustomerId}'),
            SizedBox(height: 16),
            _buildTextField('Name', _nameController),
            _buildTextField('Phone Number', _phoneNumberController),
            _buildTextField('City', _cityController),
            _buildTextField('District', _districtController),
            _buildTextField('Sub District', _subDistrictController),
            _buildTextField('Address', _addressController),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateAddressCustomer,
              child: Text('Save Changes'),
            ),
          ],
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
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  void _updateAddressCustomer() async {
    // Get the updated data from controllers
    String updatedName = _nameController.text.trim();
    String updatedPhoneNumber = _phoneNumberController.text.trim();
    String updatedCity = _cityController.text.trim();
    String updatedDistrict = _districtController.text.trim();
    String updatedSubDistrict = _subDistrictController.text.trim();
    String updatedAddress = _addressController.text.trim();

    // Create a map with updated data
    Map<String, dynamic> updatedData = {
      'name': updatedName,
      'phone_number': updatedPhoneNumber,
      'city': updatedCity,
      'district': updatedDistrict,
      'sub_district': updatedSubDistrict,
      'address': updatedAddress,
    };

    // Call the updateAddressCustomer function from your AddressCustomerFsMethods class
    try {
      AddressCustomerFsMethods().updateAddressForUser(
          _userUID, widget.addressCustomerId, updatedData);
      Navigator.of(context).pushReplacementNamed('addressCustomerMain');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AddressCustomer updated successfully'),
        ),
      );
    } catch (e) {
      print("Error updating addressCustomer: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating addressCustomer. Please try again.'),
        ),
      );
    }
  }
}
