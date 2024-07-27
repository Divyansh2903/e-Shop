import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pingolearn_assignment/models/product_model.dart';

class ApiManager {
  static const String baseUrl = 'https://dummyjson.com/products';

  Future<List<ProductElement>> fetchProducts(
      {int page = 0, int limit = 10}) async {
    final response =
        await http.get(Uri.parse('$baseUrl?limit=$limit&skip=${page * limit}'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['products'];
      return data.map((item) => ProductElement.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
