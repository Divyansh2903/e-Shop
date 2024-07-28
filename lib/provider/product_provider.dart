import 'package:flutter/material.dart';
import 'package:pingolearn_assignment/models/product_model.dart';
import 'package:pingolearn_assignment/services/api_manager.dart';

class ProductProvider with ChangeNotifier {
  List<ProductElement> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 10;
  final ApiManager _apiManager = ApiManager();

  List<ProductElement> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchProducts() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      List<ProductElement> newProducts =
          await _apiManager.fetchProducts(page: _currentPage, limit: _pageSize);
      if (newProducts.length < _pageSize) {
        _hasMore = false;
      }
      _products.addAll(newProducts);
      _currentPage++;
    } catch (e) {
      print('Error fetching products: $e');
      _hasMore = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    _products = [];
    _currentPage = 0;
    _hasMore = true;
    await fetchProducts();
  }
}
