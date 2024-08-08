import 'package:dio/dio.dart';
import 'package:fake_store_client/src/domain/domain.dart';
import 'package:fake_store_client/src/infrastructure/infrastructure.dart';

class FakeStoreController extends IFakeStoreController {
  FakeStoreController({
    this.disableLogs = false,
  }) {
    _logHelper = const LogHelperImpl();

    // ? Init Data Sources
    final client = Dio();
    final ClientHelper clientHelper = ClientHelperImpl(client: client);

    final CategoryRemoteDataSource categoryRemoteDataSource =
        CategoryRemoteDataSourceImpl(
      clientHelper: clientHelper,
    );
    final ProductRemoteDataSource productRemoteDataSource =
        ProductRemoteDataSourceImpl(
      clientHelper: clientHelper,
    );

    // ? Init Repositories
    final NetworkHelper networkHelper = NetworkHelperImpl();

    _categoryRepository = CategoryRepositoryImpl(
      remoteDataSource: categoryRemoteDataSource,
      networkHelper: networkHelper,
    );
    _productRepository = ProductRepositoryImpl(
      remoteDataSource: productRemoteDataSource,
      networkHelper: networkHelper,
    );
  }

  final bool disableLogs;

  late CategoryRepository _categoryRepository;
  late ProductRepository _productRepository;

  late LogHelper _logHelper;

  @override
  ResultFuture<List<Category>> getAllCategories() async {
    final result = await _categoryRepository.getAllCategories();
    if (!disableLogs) {
      result.whenFailure((failure) => _logHelper.showError(failure.exception));
    }

    return result;
  }

  @override
  ResultFuture<List<Product>> getAllProducts() async {
    final result = await _productRepository.getAllProducts();
    if (!disableLogs) {
      result.whenFailure((failure) => _logHelper.showError(failure.exception));
    }

    return result;
  }

  @override
  ResultFuture<Product> getProductDetail(int productId) async {
    final result = await _productRepository.getProductDetail(productId);
    if (!disableLogs) {
      result.whenFailure((failure) => _logHelper.showError(failure.exception));
    }

    return result;
  }

  @override
  ResultFuture<List<Product>> getProductsByCategory(
    String category,
  ) async {
    final result = await _productRepository.getProductsByCategory(category);
    if (!disableLogs) {
      result.whenFailure((failure) => _logHelper.showError(failure.exception));
    }

    return result;
  }
}
