import 'package:chat/models/message_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global/environment.dart';
import '../models/user.dart';
import 'auth_service.dart';

class ChatService with ChangeNotifier {
  User userParm;

  Future<List<Message>> getChat(String userID) async {
    final uri = Uri.parse('${Environment.apiUrl}/messages/${userID}');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      "x-token": await AuthService.getToken(),
    });

    final messageResponse = messageResponseFromJson(resp.body);

    return messageResponse.messages;
  }
}
