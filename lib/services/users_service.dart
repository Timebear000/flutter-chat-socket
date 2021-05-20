import 'package:chat/models/users_response.dart';

import '../global/environment.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/users');
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      });
      final usersResonse = usersResponseFromJson(resp.body);
      return usersResonse.users;
    } catch (e) {
      return [];
    }
  }
}
