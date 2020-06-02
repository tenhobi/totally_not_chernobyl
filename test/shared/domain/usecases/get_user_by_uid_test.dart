import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/shared/domain/entities/user.dart';
import 'package:totally_not_chernobyl/shared/domain/repositories/user_repository.dart';
import 'package:totally_not_chernobyl/shared/domain/usecases/get_user_by_uid.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  GetUserByUid usecase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserByUid(mockUserRepository);
  });

  final tUid = '123';
  final tUser = User(
    username: 'test',
    language: 'test',
    photoUrl: 'photo url',
  );

  test(
    'should get user for the uid from the repository',
    () async {
      // arrange
      when(mockUserRepository.getUserByUid(any))
          .thenAnswer((_) async => Right(tUser));
      // act
      final result = await usecase(GetUserByUidParams(uid: tUid));
      // assert
      expect(result, Right(tUser));
      verify(mockUserRepository.getUserByUid(tUid));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
