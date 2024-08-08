import 'dart:convert';

import 'package:fake_store_client/src/domain/domain.dart';
import 'package:fake_store_client/src/infrastructure/infrastructure.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

class MockNetworkHelper extends Mock implements NetworkHelper {}

void main() {
  late ProductRepository repository;
  late ProductRemoteDataSource mockProductRemoteDataSource;
  late MockNetworkHelper mockNetworkHelper;

  setUp(() {
    mockNetworkHelper = MockNetworkHelper();
    mockProductRemoteDataSource = MockProductRemoteDataSource();

    repository = ProductRepositoryImpl(
      networkHelper: mockNetworkHelper,
      remoteDataSource: mockProductRemoteDataSource,
    );
  });

  group('getAllProducts', () {
    // ? Success Test
    test(
      'should return a Success with a list of product',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected).thenAnswer((_) async => true);

        final jsonMap = jsonDecode(readFile('products.json'));
        final tProducts = (jsonMap as List).map((e) {
          final model = ProductModel.fromJson(e as Map<String, dynamic>);
          return model.toEntity();
        }).toList();

        when(() => mockProductRemoteDataSource.getAllProducts())
            .thenAnswer((_) async => tProducts);

        // act
        final result = await repository.getAllProducts();

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verify(() => mockProductRemoteDataSource.getAllProducts()).called(1);
        expect(result, isA<Success<List<Product>>>());
        expect(result, equals(Success<List<Product>>(tProducts)));
      },
    );

    // ? Error Internet Connection Test
    test(
      // ignore: lines_longer_than_80_chars
      'should return a Failure with NoInternetConnection when is not internet connection',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected)
            .thenAnswer((_) async => false);

        // act
        final result = await repository.getAllProducts();

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verifyNever(() => mockProductRemoteDataSource.getAllProducts());
        expect(result, isA<Failure<List<Product>>>());
        expect(
          result,
          const Failure<List<Product>>(NoInternetConnectionError()),
        );
      },
    );

    // ? Error Endpoint Test
    test(
      // ignore: lines_longer_than_80_chars
      'should return a Failure with EndPointError when has error in remote datasource',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected).thenAnswer((_) async => true);
        when(() => mockProductRemoteDataSource.getAllProducts())
            .thenThrow(const EndPointError(code: 400, endpoint: ''));

        // act
        final result = await repository.getAllProducts();

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verify(() => mockProductRemoteDataSource.getAllProducts()).called(1);
        expect(result, isA<Failure<List<Product>>>());
        expect(
          result,
          const Failure<List<Product>>(
            EndPointError(
              code: 400,
              endpoint: '',
            ),
          ),
        );
      },
    );
  });

  group('getProductDetail', () {
    // ? Success Test
    test(
      'should return a Success with a list of product belong to category',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected).thenAnswer((_) async => true);

        final jsonMap = jsonDecode(readFile('product.json')) as Map;
        final model = ProductModel.fromJson(jsonMap.cast<String, dynamic>());
        final tProduct = model.toEntity();

        when(() => mockProductRemoteDataSource.getProductDetail(1))
            .thenAnswer((_) async => tProduct);

        // act
        final result = await repository.getProductDetail(1);

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verify(() => mockProductRemoteDataSource.getProductDetail(1)).called(1);
        expect(result, isA<Success<Product>>());
        expect(result, equals(Success<Product>(tProduct)));
      },
    );

    // ? Error Internet Connection Test
    test(
      // ignore: lines_longer_than_80_chars
      'should return a Failure with NoInternetConnection when is not internet connection',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected)
            .thenAnswer((_) async => false);

        // act
        final result = await repository.getProductDetail(1);

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verifyNever(() => mockProductRemoteDataSource.getProductDetail(1));
        expect(result, isA<Failure<Product>>());
        expect(
          result,
          const Failure<Product>(NoInternetConnectionError()),
        );
      },
    );

    // ? Error Endpoint Test
    test(
      // ignore: lines_longer_than_80_chars
      'should return a Failure with EndPointError when has error in remote datasource',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected).thenAnswer((_) async => true);
        when(() => mockProductRemoteDataSource.getProductDetail(1))
            .thenThrow(const EndPointError(code: 400, endpoint: ''));

        // act
        final result = await repository.getProductDetail(1);

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verify(() => mockProductRemoteDataSource.getProductDetail(1)).called(1);
        expect(result, isA<Failure<Product>>());
        expect(
          result,
          const Failure<Product>(
            EndPointError(
              code: 400,
              endpoint: '',
            ),
          ),
        );
      },
    );
  });

  group('getProductsByCategory', () {
    // ? Success Test
    test(
      'should return a Success with a list of product belong to category',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected).thenAnswer((_) async => true);

        final jsonMap = jsonDecode(readFile('products_by_category.json'));
        final tProducts = (jsonMap as List).map((e) {
          final model = ProductModel.fromJson(e as Map<String, dynamic>);
          return model.toEntity();
        }).toList();

        when(() => mockProductRemoteDataSource.getProductsByCategory(''))
            .thenAnswer((_) async => tProducts);

        // act
        final result = await repository.getProductsByCategory('');

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verify(() => mockProductRemoteDataSource.getProductsByCategory(''))
            .called(1);
        expect(result, isA<Success<List<Product>>>());
        expect(result, equals(Success<List<Product>>(tProducts)));
      },
    );

    // ? Error Internet Connection Test
    test(
      // ignore: lines_longer_than_80_chars
      'should return a Failure with NoInternetConnection when is not internet connection',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected)
            .thenAnswer((_) async => false);

        // act
        final result = await repository.getProductsByCategory('');

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verifyNever(
          () => mockProductRemoteDataSource.getProductsByCategory(''),
        );
        expect(result, isA<Failure<List<Product>>>());
        expect(
          result,
          const Failure<List<Product>>(NoInternetConnectionError()),
        );
      },
    );

    // ? Error Endpoint Test
    test(
      // ignore: lines_longer_than_80_chars
      'should return a Failure with EndPointError when has error in remote datasource',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected).thenAnswer((_) async => true);
        when(() => mockProductRemoteDataSource.getProductsByCategory(''))
            .thenThrow(const EndPointError(code: 400, endpoint: ''));

        // act
        final result = await repository.getProductsByCategory('');

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verify(() => mockProductRemoteDataSource.getProductsByCategory(''))
            .called(1);
        expect(result, isA<Failure<List<Product>>>());
        expect(
          result,
          const Failure<List<Product>>(
            EndPointError(
              code: 400,
              endpoint: '',
            ),
          ),
        );
      },
    );
  });
}
