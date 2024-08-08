import 'dart:convert';

import 'package:fake_store_client/src/infrastructure/infrastructure.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';

class MockClientHelper extends Mock implements ClientHelper {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late ClientHelper mockClientHelper;

  setUp(() {
    registerFallbackValue(HttpMethods.get);

    mockClientHelper = MockClientHelper();
    dataSource = ProductRemoteDataSourceImpl(clientHelper: mockClientHelper);
  });

  group('getAllProducts', () {
    // ? Set up scenarios
    void setUpMockClientHelperSuccess() {
      final jsonMap = jsonDecode(readFile('products.json')) as List;

      when(
        () => mockClientHelper.makeRequest<List<dynamic>>(
          endpoint: any(named: 'endpoint'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => (200, jsonMap.cast<Map<String, dynamic>>()));
    }

    void setUpMockClientHelperFailure() {
      when(
        () => mockClientHelper.makeRequest<List<dynamic>>(
          endpoint: any(named: 'endpoint'),
          name: any(named: 'name'),
        ),
      ).thenThrow(
        const EndPointError(
          code: 400,
          endpoint: '',
        ),
      );
    }

    // ? Success Test
    test(
      'should return a list of products successful',
      () async {
        // arrange
        setUpMockClientHelperSuccess();

        final jsonMap = jsonDecode(readFile('products.json'));
        final tProducts = (jsonMap as List).map((e) {
          final model = ProductModel.fromJson(e as Map<String, dynamic>);
          return model.toEntity();
        }).toList();

        // act
        final result = await dataSource.getAllProducts();

        // assert
        verify(
          () => mockClientHelper.makeRequest<List<dynamic>>(
            endpoint: any(named: 'endpoint'),
            name: any(named: 'name'),
            method: any(named: 'method'),
          ),
        ).called(1);

        expect(result, tProducts);
      },
    );

    // ? Error Test
    test(
      'should throw a EndPointError when the response failure',
      () async {
        // arrange
        setUpMockClientHelperFailure();

        // act
        final call = dataSource.getAllProducts();

        // assert
        expect(call, throwsA(isA<EndPointError>()));
      },
    );
  });

  group('getProductDetail', () {
    // ? Set up scenarios
    void setUpMockClientHelperSuccess() {
      final jsonMap = jsonDecode(readFile('product.json')) as Map;

      when(
        () => mockClientHelper.makeRequest<Map<dynamic, dynamic>>(
          endpoint: any(named: 'endpoint'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => (200, jsonMap.cast<String, dynamic>()));
    }

    void setUpMockClientHelperFailure() {
      when(
        () => mockClientHelper.makeRequest<Map<dynamic, dynamic>>(
          endpoint: any(named: 'endpoint'),
          name: any(named: 'name'),
        ),
      ).thenThrow(
        const EndPointError(
          code: 400,
          endpoint: '',
        ),
      );
    }

    // ? Success Test
    test(
      'should return a details of product successful',
      () async {
        // arrange
        setUpMockClientHelperSuccess();

        final jsonMap = jsonDecode(readFile('product.json')) as Map;
        final model = ProductModel.fromJson(jsonMap.cast<String, dynamic>());
        final tProduct = model.toEntity();

        // act
        final result = await dataSource.getProductDetail(1);

        // assert
        verify(
          () => mockClientHelper.makeRequest<Map<dynamic, dynamic>>(
            endpoint: any(named: 'endpoint'),
            name: any(named: 'name'),
            method: any(named: 'method'),
          ),
        ).called(1);

        expect(result, tProduct);
      },
    );

    // ? Error Test
    test(
      'should throw a EndPointError when the response failure',
      () async {
        // arrange
        setUpMockClientHelperFailure();

        // act
        final call = dataSource.getProductDetail(1);

        // assert
        expect(call, throwsA(isA<EndPointError>()));
      },
    );
  });

  group('getProductsByCategory', () {
    // ? Set up scenarios
    void setUpMockClientHelperSuccess() {
      final jsonMap = jsonDecode(readFile('products_by_category.json')) as List;

      when(
        () => mockClientHelper.makeRequest<List<dynamic>>(
          endpoint: any(named: 'endpoint'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => (200, jsonMap.cast<Map<String, dynamic>>()));
    }

    void setUpMockClientHelperFailure() {
      when(
        () => mockClientHelper.makeRequest<List<dynamic>>(
          endpoint: any(named: 'endpoint'),
          name: any(named: 'name'),
        ),
      ).thenThrow(
        const EndPointError(
          code: 400,
          endpoint: '',
        ),
      );
    }

    // ? Success Test
    test(
      'should return a list of products belong to category successful',
      () async {
        // arrange
        setUpMockClientHelperSuccess();

        final jsonMap = jsonDecode(readFile('products_by_category.json'));
        final tProducts = (jsonMap as List).map((e) {
          final model = ProductModel.fromJson(e as Map<String, dynamic>);
          return model.toEntity();
        }).toList();

        // act
        final result = await dataSource.getProductsByCategory('electronics');

        // assert
        verify(
          () => mockClientHelper.makeRequest<List<dynamic>>(
            endpoint: any(named: 'endpoint'),
            name: any(named: 'name'),
            method: any(named: 'method'),
          ),
        ).called(1);

        expect(result, tProducts);
      },
    );

    // ? Error Test
    test(
      'should throw a EndPointError when the response failure',
      () async {
        // arrange
        setUpMockClientHelperFailure();

        // act
        final call = dataSource.getProductsByCategory('electronics');

        // assert
        expect(call, throwsA(isA<EndPointError>()));
      },
    );
  });
}
