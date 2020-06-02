import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/shared/domain/repositories/user_repository.dart';
import 'package:totally_not_chernobyl/shared/domain/usecases/register_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  RegisterUser usecase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = RegisterUser(mockUserRepository);
  });

  final tUid = '123';
  final tUsername = 'test';
  final tLanguage = 'test';
  final tIs = true;

  test(
    'should determine if has been registered',
    () async {
      // arrange
      when(mockUserRepository.registerUser(any, any, any))
          .thenAnswer((_) async => Right(tIs));
      // act
      final result = await usecase(RegisterUserParams(
        uid: tUid,
        username: tUsername,
        language: tLanguage,
      ));
      // assert
      expect(result, Right(tIs));
      verify(mockUserRepository.registerUser(
        tUid,
        tUsername,
        tLanguage,
      ));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
