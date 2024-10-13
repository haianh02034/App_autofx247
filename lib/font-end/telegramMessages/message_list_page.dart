import 'package:flutter/material.dart';
import '../../api/telegramMessages/messages_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class MessageListPage extends StatefulWidget {
  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  Future<List<dynamic>> _telegramMessages = Future.value([]);
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchMessagesWithToken(); // Fetch data with token
  }

  Future<void> _fetchMessagesWithToken() async {
    String? accessToken = await _storage.read(key: 'accessToken');

    print('Authorization: Bearer $accessToken');

    if (accessToken != null) {
      // Fetch messages and store the result
      setState(() {
        _telegramMessages = ApiMessagesService().fetchTelegramMessages();
      });
    } else {
      print('Access token is null. No messages will be fetched.');
    }
  }

  String _formatDate(String dateStr) {
    final DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telegram Messages'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _telegramMessages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error fetching messages: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No messages found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // Extract message data
                final message = snapshot.data![index];
                final String username = message['username'] ?? 'N/A';
                final String firstName = message['firstName'] ?? 'Unknown';
                final String lastName = message['lastName'] ?? ''; // Assuming you have a lastName field
                final String text = message['text'] ?? '(No text)'; // Ensure to replace with actual message text field
                final String date = message['date'] ?? DateTime.now().toString(); // Default to now if date is not provided
                final String formattedDate = _formatDate(date);

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(firstName[0]), // Show first letter of first name
                    ),
                    title: Text('$firstName $lastName (@$username)'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Message: $text'),
                        SizedBox(height: 4),
                        Text('Date: $formattedDate', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    onTap: () {
                      // Handle tap, e.g., show more details or navigate
                      print('Tapped on message from: $firstName');
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
