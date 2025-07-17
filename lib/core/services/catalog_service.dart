import 'package:hsp_mobile/core/models/category.dart';
import 'package:hsp_mobile/core/models/service.dart';
import 'package:hsp_mobile/core/models/service_detail.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CatalogService {
  //final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJzdHJpbmciLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjQiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJzdHJpbmciLCJGdWxsTmFtZSI6InN0cmluZyIsIkF2YXRhciI6InN0cmluZyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IjEiLCJSb2xlTmFtZSI6IiIsIlN0YXR1c0lkIjoiMSIsIlN0YXR1c05hbWUiOiIiLCJleHAiOjE3NTIxNzMyMTEsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTE2MyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTE2MyJ9.tEOyFDNkTbK2l5Gn820J1S9xvx1Nurg_bhozEjVdyr8";

  Future<Map<String, String>> get _headers async {
    final token = await SharedPrefsUtils.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Category>> getAllCategories() async {  
    final res = await http.get(
      Uri.parse('${AppConstants.baseLocalUrl}/catalog/categories'),
      headers: await _headers,
    );
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final List data = body['data'];
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Service>> getServicesByCategoryId(int categoryId) async {
    final res = await http.get(
      Uri.parse('${AppConstants.baseLocalUrl}/catalog/services/category/$categoryId'),
      headers: await _headers,
    );
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final List data = body['data'];
      return data.map((e) => Service.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  } 

  Future<List<Service>> getAllServices() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseLocalUrl}/catalog/services'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List data = jsonData['data'];
        return data.map((e) => Service.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load services: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching services: $e');
    }
  }

  Future<Service> getServiceById(int serviceId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseLocalUrl}/catalog/services/$serviceId'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Service.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to load service: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching service: $e');
    }
  }

  Future<List<ServiceDetail>> getServiceDetailsByServiceId(int serviceId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseLocalUrl}/catalog/service-details/service/$serviceId'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List data = jsonData['data'];
      return data.map((e) => ServiceDetail.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load service details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching service details: $e');
    }
  }

  //Categories
  




}