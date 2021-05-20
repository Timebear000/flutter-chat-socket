import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/user.dart';

class AuthService with ChangeNotifier {
  User user;
  bool _authenCando = false;
  bool get authenCando => this._authenCando;

  final _storage = new FlutterSecureStorage();

  set authenCando(bool valor) {
    this._authenCando = valor;
    notifyListeners();
  }

  //Getters del token
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<String> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this._authenCando = true;
    final data = {
      'email': email,
      'password': password,
    };
    final uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.authenCando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      this._keepToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> register(String name, String email, String password) async {
    this._authenCando = true;
    final data = {
      'name': name,
      'email': email,
      'password': password,
    };
    final uri = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.authenCando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      this._keepToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['error'];
    }
  }

  Future _keepToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    final uri = Uri.parse('${Environment.apiUrl}/login/renew');

    final resp = await http.get(uri,
        headers: {'Content-Type': 'application/json', 'x-token': token});
    print(resp.body);
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      this._keepToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }
}
