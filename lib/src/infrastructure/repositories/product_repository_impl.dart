import 'package:fake_store_client/src/domain/domain.dart';
import 'package:fake_store_client/src/infrastructure/infrastructure.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required ProductRemoteDataSource remoteDataSource,
    required NetworkHelper networkHelper,
  })  : _remoteDataSource = remoteDataSource,
        _networkHelper = networkHelper;

  final ProductRemoteDataSource _remoteDataSource;
  final NetworkHelper _networkHelper;

  @override
  ResultFuture<List<Product>> getAllProducts() async {
    if (!await _networkHelper.isConnected) {
      return const Failure(NoInternetConnectionError());
    }

    try {
      final products = await _remoteDataSource.getAllProducts();
      return Success(products);

      // * Errors management
    } on ConnectionTimeoutError catch (e) {
      return Failure(e);
    } on EndPointError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  ResultFuture<Product> getProductDetail(int productId) async {
    if (!await _networkHelper.isConnected) {
      return const Failure(NoInternetConnectionError());
    }

    try {
      final product = await _remoteDataSource.getProductDetail(productId);
      return Success(product);

      // * Errors management
    } on ConnectionTimeoutError catch (e) {
      return Failure(e);
    } on EndPointError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  ResultFuture<List<Product>> getProductsByCategory(
    String category,
  ) async {
    if (!await _networkHelper.isConnected) {
      return const Failure(NoInternetConnectionError());
    }

    try {
      final products = await _remoteDataSource.getProductsByCategory(category);
      return Success(products);

      // * Errors management
    } on ConnectionTimeoutError catch (e) {
      return Failure(e);
    } on EndPointError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e));
    }
  }
}
