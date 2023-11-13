<<<<<<< HEAD
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/helper_classes/firebase_auth_helper.dart';
import 'package:ecommerce_app_firebase/controller/helper_classes/firebase_firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/resources.dart';
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/helper_classes/firebase_auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> main

class drawerComponent extends StatefulWidget {
  const drawerComponent({Key? key}) : super(key: key);

  @override
  State<drawerComponent> createState() => _drawerComponentState();
}

class _drawerComponentState extends State<drawerComponent> {
<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    print(person!.displayName);
    File? img;
    Future getImage() async {
      print('hello');
      var img =
          await ImagePickerIOS().getImageFromSource(source: ImageSource.camera);
      if (img == null) return;
      final ImageTemp = File(img.path);
      setState(() {
        img = ImageTemp as XFile?;
      });
    }

    Reference refImg;
    String ImageUrl = '';
    getimg() async {
      ImagePicker imagePicker = ImagePicker();
      XFile? myImage = await imagePicker.pickImage(source: ImageSource.gallery);

      String tempFile = person!.email ?? myImage!.path;
      //initialize FirebaseStorage
      Reference reference = FirebaseStorage.instance.ref();
      //create folder in FirebaseStorage
      Reference refRoot = reference.child('clients');
      // now upload image in Folder
      refImg = refRoot.child(tempFile);
      //putting file in image
      refImg.putFile(File(myImage!.path));
      print('img_uploded');
      ImageUrl = await refImg.getDownloadURL();
      Map<String, dynamic> tempp = {
        'name': tempFile,
        'image': ImageUrl,
      };
      FireBaseStoreHelper.fireBaseStoreHelper.imageInsert(data: tempp);
    }

=======
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

  @override
  Widget build(BuildContext context) {
>>>>>>> main
    ;
    return Drawer(
      child: Builder(builder: (context) {
        return Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: Color.fromARGB(255, 19, 61, 138),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      StreamBuilder(
<<<<<<< HEAD
                        stream: FireBaseStoreHelper.db
                            .collection("customer")
                            .snapshots(),
                        builder: (context, snapshot) {
                          return Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/logo/user.png'),
                                radius: 50,
                                backgroundColor: Colors.blue,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                      Colors.blue.shade300,
                                    )),
                                    onPressed: getimg,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    )),
                              ),
                            ],
                          );
                        },
                      ),
                      Text(
                        (person!.email == null) ? '' : '${person!.email} ',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                      ),
=======
                        stream: FirebaseFirestore.instance
                            .collection("Customer")
                            .doc(_userUID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // or any other loading widget
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            var userData = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    // ... Your avatar setup
                                    ),
                                Text(
                                  userData?['first_name'] +
                                      ' ' +
                                      userData?['last_name'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  userData?['email'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                // Display other user info as needed
                              ],
                            );
                          }
                          return Text('No user data');
                        },
                      ),
>>>>>>> main
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 10,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('homePage');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.person),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Trang Mua Hàng',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('adminMain');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.person),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Trang Admin',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.person),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Thông tin',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.settings),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Cài Đặt',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.of(context).pushNamed('CartScreen');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.contact_mail),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Sổ Địa Chỉ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('CartScreen');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.shopping_cart),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Giỏ Hàng',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.help),
                              SizedBox(width: 20),
                              Text(
                                'Trợ Giúp',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await FirebaseAuthHelper.firebaseAuthHelper.signOut();
                          Navigator.pushReplacementNamed(
                              context, 'logSignPage');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.logout),
                              SizedBox(width: 20),
                              Text(
                                'Đăng Xuất',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        );
      }),
    );
  }
}
