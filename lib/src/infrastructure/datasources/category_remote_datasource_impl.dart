import 'package:fake_store_client/src/domain/domain.dart';
import 'package:fake_store_client/src/infrastructure/infrastructure.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl({
    required ClientHelper clientHelper,
  }) : _clientHelper = clientHelper;

  final ClientHelper _clientHelper;

  @override
  Future<List<Category>> getAllCategories() async {
    const nameEndpoint = 'GetAllCategories';

    final (_, response) = await _clientHelper.makeRequest<List<dynamic>>(
      endpoint: 'products/categories',
      name: nameEndpoint,
    );

    if (response == null) {
      throw const EmptyDataError(endpoint: nameEndpoint);
    }

    final categories = response
        .map((category) => Category(name: category.toString()))
        .toList();

    return categories;
  }
}
