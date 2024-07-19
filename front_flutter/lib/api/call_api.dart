import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class ApiService {
  static const String baseUrl = Config.apiUrl;

  static Future<List<dynamic>> fetchLoisirs() async {
    final response = await http.get(Uri.parse('${baseUrl}loisir/all'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load loisirs');
    }
  }

  static Future<List<dynamic>> fetchTypes() async {
    final response = await http.get(Uri.parse('${baseUrl}type/all'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load types');
    }
  }

  static Future<dynamic> fetchTopLoisir() async {
    final response = await http.get(Uri.parse('${baseUrl}loisir/top'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top loisir');
    }
  }

  static Future<List<dynamic>> fetchLoisirsByType(int typeId) async {
    final response =
        await http.get(Uri.parse('${baseUrl}loisir/getByType/$typeId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load loisirs by type');
    }
  }

  static Future<void> createLoisir(Map<String, dynamic> loisirData) async {
    final response = await http.post(
      Uri.parse('${baseUrl}loisir/create'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loisirData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create loisir');
    }
  }

  static Future<Map<String, dynamic>> fetchTypeById(int typeId) async {
    final response = await http.get(Uri.parse('${baseUrl}type/$typeId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load type by id');
    }
  }
}
