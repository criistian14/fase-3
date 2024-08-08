import 'package:fake_store_client/src/domain/domain.dart';
import 'package:fake_store_client/src/infrastructure/infrastructure.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({
    required CategoryRemoteDataSource remoteDataSource,
    required NetworkHelper networkHelper,
  })  : _remoteDataSource = remoteDataSource,
        _networkHelper = networkHelper;

  final CategoryRemoteDataSource _remoteDataSource;
  final NetworkHelper _networkHelper;

  @override
  ResultFuture<List<Category>> getAllCategories() async {
    if (!await _networkHelper.isConnected) {
      return const Failure(NoInternetConnectionError());
    }

    try {
      final categories = await _remoteDataSource.getAllCategories();
      return Success(categories);

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
