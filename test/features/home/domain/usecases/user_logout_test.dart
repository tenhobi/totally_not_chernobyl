import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/core/usecases/usecase.dart';
import 'package:totally_not_chernobyl/feature/home/domain/repositories/auth_repository.dart';
import 'package:totally_not_chernobyl/feature/home/domain/usecases/user_logout.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  UserLogOut usecase;
  MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = UserLogOut(mockAuthRepository);
  });

  test(
    'should log out user from the repository',
    () async {
      // arrange
      when(mockAuthRepository.logOut()).thenAnswer((_) async => Right(null));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(null));
      verify(mockAuthRepository.logOut());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
