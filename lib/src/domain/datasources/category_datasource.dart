import 'package:fake_store_client/src/domain/domain.dart';

/// [CategoryRemoteDataSource] interface for fetching category data
/// from a remote source.
abstract class CategoryRemoteDataSource {
  /// Fetches all available categories from the remote source
  ///
  /// Returns a list of [Category] objects that belong to the specified category
  /// Throws an exception if there is an error during the data retrieval
  Future<List<Category>> getAllCategories();
}
