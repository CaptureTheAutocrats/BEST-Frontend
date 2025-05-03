import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  String name;
  String? description;
  double price;
  int stock;
  String condition;
  String image;

  Product({
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.condition,
    required this.image,
  });

  Product.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String,
      description = json['description'] as String?,
      price = json['price'] as double,
      stock = json['stock'] as int,
      condition = json['product_condition'] as String,
      image = json['image'] as String;
}

class APIService {
  final String _baseUrl = 'https://catchmeifyoucan.xyz/best';
  static String? _token;
  static SharedPreferences? _sharedPreferences;

  Future<void> _setToken(String newToken) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences!.setString("api-token", newToken);
    _token = newToken;
  }

  static final APIService _apiService = APIService._();

  APIService._() {
    SharedPreferences.getInstance()
        .then((pref) {
          _sharedPreferences = pref;
          _token = pref.getString("api-token");
        })
        .catchError(print);
  }

  factory APIService() {
    return _apiService;
  }

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String studentId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/register.php'),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'BESTFrontend',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'student_id': studentId,
      }),
    );

    if (response.statusCode != 200) return false;

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final newToken = json['token'] as String?;

    if (newToken == null) return false;
    await _setToken(newToken);

    return true;
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/login.php'),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'BESTFrontend',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) return false;

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final newToken = json['token'] as String?;

    if (newToken == null) return false;
    await _setToken(newToken);

    return true;
  }

  Future<List<Product>> fetchAllProducts({int page = 1, int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/products.php?page=$page&limit=$limit'),
      headers: {'User-Agent': 'BESTFontend', 'Authorization': 'Bearer $_token'},
    );

    print(response.body);
    final json = jsonDecode(response.body) as List<dynamic>;
    return json.map((productJson) => Product.fromJson(productJson)).toList();
  }

  Future<bool> uploadProduct({
    required String name,
    required String description,
    required double price,
    required String productCondition,
    required int stock,
    required String base64Image,
  }) async {
    final jsonBody = jsonEncode({
      'name': name,
      'description': description,
      'price': price,
      'product_condition': productCondition,
      'stock': stock,
      'image': base64Image,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/api/add-product.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
        'User-Agent': 'BESTFrontend',
      },
      body: jsonBody,
    );

    return response.statusCode == 201;
  }
}

void main() {
  APIService().fetchAllProducts().then(print);
}
