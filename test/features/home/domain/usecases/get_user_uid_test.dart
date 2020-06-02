import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/core/usecases/usecase.dart';
import 'package:totally_not_chernobyl/feature/home/domain/repositories/auth_repository.dart';
import 'package:totally_not_chernobyl/feature/home/domain/usecases/get_user_uid.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  GetUserUid usecase;
  MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetUserUid(mockAuthRepository);
  });

  final tUid = '123';
  final tIs = true;

  test(
    'should get uid of the user from the repository',
    () async {
      // arrange
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => Right(tIs));
      when(mockAuthRepository.getUid()).thenAnswer((_) async => Right(tUid));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tUid));
      verify(mockAuthRepository.isLoggedIn());
      verify(mockAuthRepository.getUid());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
