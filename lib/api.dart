import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  int productId;
  int userId;
  String name;
  String? description;
  double price;
  int stock;
  String condition;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  Product({
    required this.productId,
    required this.userId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.condition,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'Product(id: $productId, name: $name, price: $price, stock: $stock, condition: $condition, createdAt: $createdAt)';
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'user_id': userId,
    'name': name,
    'description': description,
    'price': price,
    'stock': stock,
    'product_condition': condition,
    'image_path': image,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Product.fromJson(Map<String, dynamic> json)
    : productId = json['product_id'] as int,
      userId = json['user_id'] as int,
      name = json['name'] as String,
      description = json['description'] as String?,
      price = (json['price'] as num).toDouble(),
      stock = (json['stock'] as num).toInt(),
      condition = json['product_condition'] as String,
      image = json['image_path'] as String,
      createdAt = DateTime.parse(json['created_at']),
      updatedAt = DateTime.parse(json['updated_at']);
}

class APIService {
  final String _baseUrl = 'https://catchmeifyoucan.xyz/best';
  static String? _token;
  DateTime? _tokenExpiresAt;
  static SharedPreferences? _sharedPreferences;

  Future<void> _setToken(String newToken, int expiresAt) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences!.setString("api-token", newToken);
    _sharedPreferences!.setInt("api-token-expires-at", expiresAt);
    _token = newToken;
    _tokenExpiresAt = DateTime.fromMillisecondsSinceEpoch(
      expiresAt * 1000,
      isUtc: true,
    );
  }

  Future<void> _refreshTokenFromSharedPreferences() =>
      SharedPreferences.getInstance()
          .then((pref) {
            _sharedPreferences = pref;
            _token = pref.getString("api-token");
            int? expiresAt = pref.getInt("api-token-expires-at");
            if (expiresAt != null) {
              _tokenExpiresAt = DateTime.fromMillisecondsSinceEpoch(
                expiresAt * 1000,
                isUtc: true,
              );
            }
          })
          .catchError((err) {
            if (kDebugMode) {
              print(err);
            }
          });

  static final APIService _apiService = APIService._();

  APIService._() {
    _refreshTokenFromSharedPreferences();
  }

  factory APIService() {
    return _apiService;
  }

  Future<bool> isLoggedIn() async {
    if (_sharedPreferences == null) await _refreshTokenFromSharedPreferences();
    return _token != null &&
        _tokenExpiresAt != null &&
        (_tokenExpiresAt?.isAfter(DateTime.now()) ?? false);
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

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print("${response.statusCode} - ${response.body}");
      }
      return false;
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final newToken = json['token'] as String;
    final newExpiresAt = json['tokenExpiresAt'] as int;

    await _setToken(newToken, newExpiresAt);
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
    final newToken = json['token'] as String;
    final newExpiresAt = json['tokenExpiresAt'] as int;

    await _setToken(newToken, newExpiresAt);
    return true;
  }

  Future<List<Product>> fetchAllProducts({int page = 1, int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/products.php?page=$page&limit=$limit'),
      headers: {'User-Agent': 'BESTFontend', 'Authorization': 'Bearer $_token'},
    );

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
    required String imageExtension,
  }) async {
    final jsonBody = jsonEncode({
      'name': name,
      'description': description,
      'price': price,
      'product_condition': productCondition,
      'stock': stock,
      'image': base64Image,
      'image_ext': imageExtension,
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

    if (response.statusCode != 201) {
      if (kDebugMode) {
        print("${response.statusCode} - ${response.body}");
      }
    }

    return response.statusCode == 201;
  }
}
