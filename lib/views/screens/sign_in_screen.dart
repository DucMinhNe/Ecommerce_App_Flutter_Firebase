import 'package:flutter/material.dart';

import '../../controller/helper_classes/firebase_auth_helper.dart';
import '../../models/resources.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.blue.shade200,
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: const Icon(
        //     Icons.arrow_back_ios_rounded,
        //     size: 20,
        //   ),
        // ),
      ),
      body: Container(
        color: Colors.blue.shade200,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.blue.shade200,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Đăng Nhập',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        'Xin chào, chào mừng đến với LifeTech \n',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(-1, -2),
                          blurRadius: 15),
                    ],
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(70))),
                child: Form(
                  key: SignInKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold),
                              contentPadding: EdgeInsets.all(25),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.email_rounded,
                                  size: 25,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              fillColor: Colors.grey.shade200,
                              focusColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                            ),
                            controller: emailController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Vui lòng điền Email...';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              email = val;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold),
                              contentPadding: const EdgeInsets.all(25),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.password,
                                  size: 25,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              fillColor: Colors.grey.shade200,
                              focusColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    {
                                      if (viewPassword == true) {
                                        viewPassword = false;
                                      } else {
                                        viewPassword = true;
                                      }
                                    }
                                  });
                                },
                                child: (viewPassword == true)
                                    ? const Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 20,
                                        color: Colors.grey,
                                      )
                                    : const Icon(
                                        Icons.remove_red_eye,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            obscuringCharacter: '*',
                            obscureText: viewPassword,
                            controller: passwordController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Vui lòng điền mật khẩu...';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () {},
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Chưa có tài khoản? Đăng ký ngay        ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () {},
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Quên Mật Khẩu?',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all(
                                Colors.black,
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.black,
                              ),
                            ),
                            onPressed: () async {
                              if (SignInKey.currentState!.validate()) {
                                SignInKey.currentState!.save();
                                Map<String, dynamic> res =
                                    await FirebaseAuthHelper.firebaseAuthHelper
                                        .signInWithEmailPassword(
                                            email: email!, password: password!);
                                if (res['error'] != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        '${res['error']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (res['user'] != null) {
                                  person = res['user'];
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Đăng Nhập Thành Công',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                  Navigator.pushReplacementNamed(
                                      context, 'homePage');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Sai tài khoản hoặc mật khẩu',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Đăng Nhập',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade50,
                              Colors.grey.shade50,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )),
                          child: InkWell(
                            onTap: () async {
                              Map<String, dynamic> result =
                                  await FirebaseAuthHelper.firebaseAuthHelper
                                      .signInWithGoogle();
                              // Check the result and navigate accordingly
                              if (result.containsKey('user')) {
                                // Successful login with Google, navigate to home or other screen
                                Navigator.pushReplacementNamed(
                                    context, 'homePage');
                              } else if (result.containsKey('error')) {
                                // Handle the error
                                Navigator.pushReplacementNamed(
                                    context, 'homePage');
                                print(
                                    "Google Sign-In Error: ${result['error']}");
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 0.5,
                                  child: Image.asset(
                                      'assets/images/stocks/google.png'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
