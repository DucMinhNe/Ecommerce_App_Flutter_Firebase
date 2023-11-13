import 'package:flutter/material.dart';

class LogSignPage extends StatefulWidget {
  const LogSignPage({Key? key}) : super(key: key);

  @override
  State<LogSignPage> createState() => _LogSignPageState();
}

class _LogSignPageState extends State<LogSignPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset('assets/images/lifetech.png'),
              SizedBox(
                  height:
                      100.0), // Sử dụng SizedBox để thêm khoảng cách dưới hình ảnh
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'signInScreen');
                },
                child: const Text('Đăng Nhập'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'logInScreen');
                },
                child: const Text('Đăng Ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
