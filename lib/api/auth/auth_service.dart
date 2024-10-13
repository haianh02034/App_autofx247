import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final _storage = FlutterSecureStorage();

  // Function to log the user in
  static Future<bool> login(String email, String password, BuildContext context) async {
    var url = '${dotenv.env['API_URL']}/api/auth/login'; // Load API URL from .env

    try {
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      // Log the response status and body
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Accept both 200 and 201 status codes as successful login
      if (response.statusCode == 200 || response.statusCode == 201) {
        var loginResponse = jsonDecode(response.body);

        // Log the parsed response
        print('Parsed response: $loginResponse');

        // Check if accessToken is returned correctly
        if (loginResponse['accessToken'] != null) {
          // Log the received accessToken
          print('AccessToken received: ${loginResponse['accessToken']}');

          // Store the access token securely
          await _storage.write(key: 'accessToken', value: loginResponse['accessToken']);
          return true; // Return true if login was successful
        } else {
          print('AccessToken missing in the response');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('AccessToken missing in the response')),
          );
          return false; // Return false if accessToken is missing
        }
      } else {
        // Handle login failure and provide feedback
        print('Login failed with status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
        return false; // Return false if the status code is not 200 or 201
      }
    } catch (error) {
      // Log any exceptions or errors
      print('Error during login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during login: $error')),
      );
      return false; // Return false in case of error
    }
  }

  // Function to get the access token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'accessToken');
  }

  // Function to log out and remove the token
  static Future<void> logout(BuildContext context) async {
  await _storage.delete(key: 'accessToken');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out successfully')),
    );
  }

  // Function to register a new user
  static Future<void> register(String email, String password, BuildContext context) async {
    try {
      var url = '${dotenv.env['API_URL']}/api/auth/register';
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Registration successful: ${data['accessToken']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful')),
        );
        Navigator.pushNamed(context, '/home', arguments: data);
      } else {
        print('Registration failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
        );
      }
    } catch (e) {
      print('Registration error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration error: $e')),
      );
    }
  }

  // Function to get the current user details (/me endpoint)
  static Future<void> me(BuildContext context) async {
    try {
      var url = '${dotenv.env['API_URL']}/api/auth/me';

      // Retrieve access token from secure storage
      String? accessToken = await getToken();

      if (accessToken == null) {
        print('No access token found. Please log in.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No access token found. Please log in.')),
        );
        return;
      }

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken', // Include the stored accessToken in the Authorization header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('User info: $data');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User info retrieved')),
        );
      } else {
        print('Failed to retrieve user info: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to retrieve user info')),
        );
      }
    } catch (e) {
      print('Error retrieving user info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user info: $e')),
      );
    }
  }
}
