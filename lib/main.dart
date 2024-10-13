import 'package:flutter/material.dart';
import 'package:login_app/font-end/telegramMessages/message_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './font-end/auth/login_page.dart';
import './font-end/dashboard/home_page.dart'; // Import HomePage

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  
  // Kiểm tra trạng thái đăng nhập trước khi khởi động ứng dụng
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  // Truyền trạng thái đăng nhập qua constructor
  MyApp({required this.isLoggedIn});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Nếu đã đăng nhập thì chuyển đến HomePage, nếu không thì LoginPage
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/messages': (context) => MessageListPage(), // New MessageListPage route

      },
    );
  }
}
