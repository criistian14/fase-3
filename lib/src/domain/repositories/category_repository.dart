import 'package:fake_store_client/src/domain/domain.dart';

/// [CategoryRepository] is an abstract class that defines the interface
/// for accessing category data from a repository, handling data operations
/// and error management using the `Either` type.
abstract class CategoryRepository {
  /// Fetches all available categories from data source
  ///
  /// Returns an [Either] containing a list of [Category] if successful,
  /// or an [Exception] if there is an error during the data retrieval
  ResultFuture<List<Category>> getAllCategories();
}
