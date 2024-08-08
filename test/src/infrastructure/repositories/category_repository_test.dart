import 'dart:convert';

import 'package:fake_store_client/src/domain/domain.dart';
import 'package:fake_store_client/src/infrastructure/infrastructure.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';

class MockCategoryRemoteDataSource extends Mock
    implements CategoryRemoteDataSource {}

class MockNetworkHelper extends Mock implements NetworkHelper {}

void main() {
  late CategoryRepository repository;
  late CategoryRemoteDataSource mockCategoryRemoteDataSource;
  late MockNetworkHelper mockNetworkHelper;

  setUp(() {
    mockNetworkHelper = MockNetworkHelper();
    mockCategoryRemoteDataSource = MockCategoryRemoteDataSource();

    repository = CategoryRepositoryImpl(
      networkHelper: mockNetworkHelper,
      remoteDataSource: mockCategoryRemoteDataSource,
    );
  });

  group('getAllCategories', () {
    // ? Success Test
    test(
      'should return a Right with a list of category',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected).thenAnswer((_) async => true);

        final jsonMap = jsonDecode(readFile('categories.json'));
        final tCategories =
            (jsonMap as List).map((e) => Category(name: e.toString())).toList();

        when(() => mockCategoryRemoteDataSource.getAllCategories())
            .thenAnswer((_) async => tCategories);

        // act
        final result = await repository.getAllCategories();

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verify(() => mockCategoryRemoteDataSource.getAllCategories()).called(1);
        expect(result, isA<Success<List<Category>>>());
        expect(result, equals(Success<List<Category>>(tCategories)));
      },
    );

    // ? Error Internet Connection Test
    test(
      // ignore: lines_longer_than_80_chars
      'should return a Left with NoInternetConnection when is not internet connection',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected)
            .thenAnswer((_) async => false);

        // act
        final result = await repository.getAllCategories();

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verifyNever(() => mockCategoryRemoteDataSource.getAllCategories());
        expect(result, isA<Failure<List<Category>>>());
        expect(
          result,
          const Failure<List<Category>>(NoInternetConnectionError()),
        );
      },
    );

    // ? Error Endpoint Test
    test(
      // ignore: lines_longer_than_80_chars
      'should return a Left with EndPointError when has error in remote datasource',
      () async {
        // arrange
        when(() => mockNetworkHelper.isConnected).thenAnswer((_) async => true);
        when(() => mockCategoryRemoteDataSource.getAllCategories())
            .thenThrow(const EndPointError(code: 400, endpoint: ''));

        // act
        final result = await repository.getAllCategories();

        // assert
        verify(() => mockNetworkHelper.isConnected).called(1);
        verify(() => mockCategoryRemoteDataSource.getAllCategories()).called(1);
        expect(result, isA<Failure<List<Category>>>());
        expect(
          result,
          const Failure<List<Category>>(
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
