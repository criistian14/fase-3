import 'dart:convert';

import 'package:fake_store_client/src/domain/domain.dart';
import 'package:fake_store_client/src/infrastructure/infrastructure.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';

class MockClientHelper extends Mock implements ClientHelper {}

void main() {
  late CategoryRemoteDataSourceImpl dataSource;
  late ClientHelper mockClientHelper;

  setUp(() {
    registerFallbackValue(HttpMethods.get);

    mockClientHelper = MockClientHelper();
    dataSource = CategoryRemoteDataSourceImpl(clientHelper: mockClientHelper);
  });

  group('getAllCategories', () {
    // ? Set up scenarios
    void setUpMockClientHelperSuccess() {
      final jsonMap = jsonDecode(readFile('categories.json')) as List;

      when(
        () => mockClientHelper.makeRequest<List<dynamic>>(
          endpoint: any(named: 'endpoint'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => (200, jsonMap.cast<String>()));
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
      'should return a list of categories successful',
      () async {
        // arrange
        setUpMockClientHelperSuccess();

        final jsonMap = jsonDecode(readFile('categories.json'));
        final tCategories =
            (jsonMap as List).map((e) => Category(name: e.toString())).toList();

        // act
        final result = await dataSource.getAllCategories();

        // assert
        verify(
          () => mockClientHelper.makeRequest<List<dynamic>>(
            endpoint: any(named: 'endpoint'),
            name: any(named: 'name'),
            method: any(named: 'method'),
          ),
        ).called(1);

        expect(result, tCategories);
      },
    );

    // ? Error Test
    test(
      'should throw a EndPointError when the response failure',
      () async {
        // arrange
        setUpMockClientHelperFailure();

        // act
        final call = dataSource.getAllCategories();

        // assert
        expect(call, throwsA(isA<EndPointError>()));
      },
    );
  });
}
