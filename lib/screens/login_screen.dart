import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/utils/mostar_alert.dart';
import 'package:chat/widgets/button_blue.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(title: 'Messenger'),
                _Form(),
                Labels(
                    route: 'register',
                    title: '아직 회원이 아닌가요?',
                    subtitle: '이곳에서 회원 가입을 진행해주세요.'),
                Text(
                  'Shuiing',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final _emailCtroller = TextEditingController();
  final _passwordCtroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            controller: _emailCtroller,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            controller: _passwordCtroller,
            isPassword: true,
          ),
          // TextField(),
          ButtonBlue(
            title: 'Login',
            onPressed: authService.authenCando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                        _emailCtroller.text.trim(),
                        _passwordCtroller.text.trim());
                    if (loginOk) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'user');
                    } else {
                      mostrarAlerta(context, 'Login Faild', '다시 입력해주세요.');
                    }
                  },
          ),
        ],
      ),
    );
  }
}
