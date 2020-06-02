import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/core/usecases/usecase.dart';
import 'package:totally_not_chernobyl/feature/home/domain/repositories/auth_repository.dart';
import 'package:totally_not_chernobyl/feature/home/domain/usecases/user_login.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  UserLogIn usecase;
  MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = UserLogIn(mockAuthRepository);
  });

  final tUid = '123';

  test(
    'should log in user using the repository',
    () async {
      // arrange
      when(mockAuthRepository.logIn()).thenAnswer((_) async => Right(tUid));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tUid));
      verify(mockAuthRepository.logIn());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
