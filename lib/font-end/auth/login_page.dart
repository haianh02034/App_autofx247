import 'package:flutter/material.dart';
import '../../api/auth/auth_service.dart'; // Import AuthService
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // To show a loading indicator during login

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    bool isLoggedIn = await AuthService.login(email, password ,context);

    setState(() {
      _isLoading = false;
    });

    if (isLoggedIn) {
      // Lưu trạng thái đăng nhập vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Điều hướng đến HomePage
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Hiển thị thông báo lỗi nếu đăng nhập thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed, please check your credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(height: 30),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            style: TextStyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(height: 40),
                          _isLoading
                              ? CircularProgressIndicator() // Show loading indicator while logging in
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sign in',
                                      style: TextStyle(
                                          fontSize: 27, fontWeight: FontWeight.w700),
                                    ),
                                    CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Color(0xff4c505b),
                                    child: IconButton(
                                      color: Colors.white,
                                      onPressed: _login, // Trigger login
                                      icon: Icon(Icons.arrow_forward, color: Colors.white), // Ensure color is set here
                                    ),
                                  )

                                  ],
                                ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'register');
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
