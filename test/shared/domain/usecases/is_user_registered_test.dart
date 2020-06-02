import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/shared/domain/repositories/user_repository.dart';
import 'package:totally_not_chernobyl/shared/domain/usecases/is_user_registered.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  IsUserRegistered usecase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = IsUserRegistered(mockUserRepository);
  });

  final tUid = '123';
  final tIs = true;

  test(
    'should determine if user is registered',
    () async {
      // arrange
      when(mockUserRepository.isUserRegistered(any))
          .thenAnswer((_) async => Right(tIs));
      // act
      final result = await usecase(IsUserRegisteredParams(uid: tUid));
      // assert
      expect(result, Right(tIs));
      verify(mockUserRepository.isUserRegistered(tUid));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
