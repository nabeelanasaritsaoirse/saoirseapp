import '../models/LoginAuth/login_response/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse?> authlogin({required String idToken});
}
