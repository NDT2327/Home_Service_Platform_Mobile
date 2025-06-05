import 'dart:convert';
import 'package:hsp_mobile/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:hsp_mobile/utils/constants.dart';

class ApiService {

  static Future<List<User>> fetchUsers() async {
    
    final response = await http.get(Uri.parse('${AppConstants.baseUrl}/users'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
