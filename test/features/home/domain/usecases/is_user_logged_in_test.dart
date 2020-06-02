import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/core/usecases/usecase.dart';
import 'package:totally_not_chernobyl/feature/home/domain/repositories/auth_repository.dart';
import 'package:totally_not_chernobyl/feature/home/domain/usecases/is_user_logged_in.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  IsUserLoggedIn usecase;
  MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = IsUserLoggedIn(mockAuthRepository);
  });

  final tIs = true;

  test(
    'should determine if the user is logged in from the repository',
    () async {
      // arrange
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => Right(tIs));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tIs));
      verify(mockAuthRepository.isLoggedIn());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
