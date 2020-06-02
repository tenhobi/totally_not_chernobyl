import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/shared/domain/entities/user.dart';
import 'package:totally_not_chernobyl/shared/domain/repositories/user_repository.dart';
import 'package:totally_not_chernobyl/shared/domain/usecases/save_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  SaveUser usecase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = SaveUser(mockUserRepository);
  });

  final tUid = '123';
  final tUser = User(
    username: 'test',
    language: 'test',
    photoUrl: 'photo url',
  );
  final tIs = true;

  test(
    'should determine if user has been saved',
    () async {
      // arrange
      when(mockUserRepository.saveUser(any, any))
          .thenAnswer((_) async => Right(tIs));
      // act
      final result = await usecase(SaveUserParams(uid: tUid, user: tUser));
      // assert
      expect(result, Right(tIs));
      verify(mockUserRepository.saveUser(tUid, tUser));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
