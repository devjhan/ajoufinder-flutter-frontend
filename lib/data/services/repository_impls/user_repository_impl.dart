import 'package:ajoufinder/data/dto/sign_up_request.dart';
import 'package:ajoufinder/data/dto/sign_up_response.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository{
  @override
  Future<User> findById(int id) async {
    //추후 구현 필요
    throw UnimplementedError();
  }

  @override
  Future<SignUpResponse> signUp(SignUpRequest request) async {
    //추후 구현
    throw UnimplementedError();
  }
}