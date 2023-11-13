import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  String _gender = '';
  String _phoneNumber = '';

  Future<void> _registerWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      if (userCredential.user != null) {
        String userUid = userCredential.user!.uid;

        // Lưu thông tin người dùng vào Firestore
        await FirebaseFirestore.instance
            .collection('Customer')
            .doc(userUid)
            .set({
          'email': _email,
          'first_name': _firstName,
          'last_name': _lastName,
          'gender': _gender,
          'phone_number': _phoneNumber,
          // Các thông tin khác của người dùng
        });

        // Đăng ký thành công, chuyển đến trang chính hoặc thực hiện các hành động khác
        Navigator.pushReplacementNamed(context, 'signInScreen');
      }
    } catch (e) {
      print(e.toString());
      // Xử lý lỗi đăng ký, ví dụ: hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng ký không thành công. Vui lòng thử lại.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập email.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập mật khẩu.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
                obscureText: true,
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (value) {
                  _firstName = value!;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (value) {
                  _lastName = value!;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
                onSaved: (value) {
                  _gender = value!;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    _registerWithEmailAndPassword();
                  }
                },
                child: Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
