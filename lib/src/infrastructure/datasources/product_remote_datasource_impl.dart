import 'package:fake_store_client/src/domain/domain.dart';
import 'package:fake_store_client/src/infrastructure/infrastructure.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl({
    required ClientHelper clientHelper,
  }) : _clientHelper = clientHelper;

  final ClientHelper _clientHelper;

  @override
  Future<List<Product>> getAllProducts() async {
    const nameEndpoint = 'GetAllProducts';

    final (_, response) = await _clientHelper.makeRequest<List<dynamic>>(
      endpoint: 'products',
      name: nameEndpoint,
    );

    if (response == null) {
      throw const EmptyDataError(endpoint: nameEndpoint);
    }

    final products = response.map((json) {
      final model = ProductModel.fromJson(json as Map<String, dynamic>);
      return model.toEntity();
    }).toList();

    return products;
  }

  @override
  Future<Product> getProductDetail(int productId) async {
    const nameEndpoint = 'GetProductDetail';

    final (_, response) =
        await _clientHelper.makeRequest<Map<dynamic, dynamic>>(
      endpoint: 'products/$productId',
      name: nameEndpoint,
    );

    if (response == null) {
      throw const EmptyDataError(endpoint: nameEndpoint);
    }

    final model = ProductModel.fromJson(response.cast());

    return model.toEntity();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    const nameEndpoint = 'GetProductsByCategory';

    final (_, response) = await _clientHelper.makeRequest<List<dynamic>>(
      endpoint: 'products/category/$category',
      name: nameEndpoint,
    );

    if (response == null) {
      throw const EmptyDataError(endpoint: nameEndpoint);
    }

    final products = response.map((json) {
      final model = ProductModel.fromJson(json as Map<String, dynamic>);
      return model.toEntity();
    }).toList();

    return products;
  }
}
