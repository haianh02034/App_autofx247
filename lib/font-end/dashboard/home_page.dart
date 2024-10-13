import 'package:flutter/material.dart';
import 'package:login_app/api/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../telegramMessages/message_list_page.dart'; // Thêm import để điều hướng đến trang MessagesPage
// import 'settings_page.dart'; // Thêm import để điều hướng đến trang SettingsPage
import '../layout/BottomNavigationBar/custom_bottom_navigation_bar.dart'; // Import BottomNavigationBar tùy chỉnh




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Chỉ số của trang hiện tại
  final String userName = "John Doe";
  final String userEmail = "john.doe@example.com";

  // Danh sách các trang sẽ hiển thị
  final List<Widget> _pages = [
    Center(child: Text('Welcome to Home Page!')),
    MessageListPage(), // Trang hiển thị danh sách tin nhắn
    Center(child: Text('Settings Page')) // Trang hiển thị cài đặt
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật trang hiện tại
    });

    // Điều hướng đến các trang khác nhau khi nhấn vào mục tương ứng
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/messages'); // Điều hướng đến trang messages
        break;
      case 2:
        Navigator.pushNamed(context, '/settings'); // Điều hướng đến trang settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autofx 247'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Mở menu bên trái
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(userName), // Hiển thị tên người dùng
              accountEmail: Text(userEmail), // Hiển thị email người dùng
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/icon/app_icon.png'), // Đường dẫn tới ảnh đại diện
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent, // Màu nền cho header
              ),
            ),
            Spacer(),
            Divider(),    
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await AuthService.logout(context); // Truyền context vào đây
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Hiển thị nội dung dựa trên trang đã chọn
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
