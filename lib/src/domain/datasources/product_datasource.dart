import 'package:fake_store_client/src/domain/domain.dart';

/// [ProductRemoteDataSource] interface for fetching product data
/// from a remote source.
abstract class ProductRemoteDataSource {
  /// Fetches all available products from the remote source
  ///
  /// Returns a list of [Product] objects
  /// Throws an exception if there is an error during the data retrieval
  Future<List<Product>> getAllProducts();

  /// Fetches the details of a specific product by its ID from the remote source
  ///
  /// Parameters:
  /// - [productId]: An integer representing the product ID.
  ///
  /// Returns a [Product] object containing the product details
  /// Throws an exception if there is an error during the data retrieval
  Future<Product> getProductDetail(int productId);

  /// Fetches products that belong to a specific category from the remote source
  ///
  /// Parameters:
  /// - [category]: A string representing the product category
  ///
  /// Returns a list of [Product] objects that belong to the specified category
  /// Throws an exception if there is an error during the data retrieval
  Future<List<Product>> getProductsByCategory(String category);
}
