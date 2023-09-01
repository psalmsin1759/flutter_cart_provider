import 'dart:convert';
import 'package:http/http.dart';

import '../model/product.dart';

class HttpService {
  final String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> getProductList() async {
    final response = await get(Uri.parse('$baseUrl/products'), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Product> productList = data
          .map((json) => Product(
                id: json['id'],
                title: json['title'],
                price: json['price'].toDouble(),
                description: json['description'],
                category: json['category'],
                image: json['image'],
              ))
          .toList();
      return productList;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
