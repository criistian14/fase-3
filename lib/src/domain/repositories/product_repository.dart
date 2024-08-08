import 'package:fake_store_client/src/domain/domain.dart';

/// [ProductRepository] is an abstract class that defines the interface
/// for accessing product data from a repository, handling data operations
/// and error management using the `Either` type.
abstract class ProductRepository {
  /// Fetches all available products from data source
  ///
  /// Returns an [Either] containing a list of [Product] if successful,
  /// or an [Exception] if there is an error during the data retrieval
  ResultFuture<List<Product>> getAllProducts();

  /// Fetches the details of a specific product from data source
  ///
  /// Parameters:
  /// - [productId]: A int representing the product ID
  ///
  /// Returns an [Either] containing a  [Product] if successful,
  /// or an [Exception] if there is an error during the data retrieval
  ResultFuture<Product> getProductDetail(int productId);

  /// Fetches products that belong to a specific category from data source
  ///
  /// Parameters:
  /// - [category]: A string representing the name of category
  ///
  /// Returns an [Either] containing a list of [Product] if successful,
  /// or an [Exception] if there is an error during the data retrieval
  ResultFuture<List<Product>> getProductsByCategory(
    String category,
  );
}
