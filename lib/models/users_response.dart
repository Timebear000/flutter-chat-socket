// To parse this JSON data, do
//
//     final usersResponse = usersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/user.dart';

UsersResponse usersResponseFromJson(String str) =>
    UsersResponse.fromJson(json.decode(str));

String usersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {
  UsersResponse({
    this.success,
    this.users,
  });

  bool success;
  List<User> users;

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        success: json["success"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}
