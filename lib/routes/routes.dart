import 'package:chat/screens/chat_Screen.dart';
import 'package:chat/screens/loading_screen.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/register_screen.dart';
import 'package:chat/screens/user_screen.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'user': (_) => UserScreen(),
  'chat': (_) => ChatScreen(),
  'register': (_) => RegisterScreen(),
  'login': (_) => LoginScreen(),
  'loading': (_) => LoadingScreen(),
};
