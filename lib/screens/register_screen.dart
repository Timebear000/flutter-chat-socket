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

class RegisterScreen extends StatelessWidget {
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
                Logo(title: 'Register'),
                _Form(),
                Labels(
                  route: 'login',
                  title: '이미 가입된 사용자인가요?',
                  subtitle: '이곳에서 로그인을 해주세요',
                ),
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
  final _nameCtroller = TextEditingController();
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
            icon: Icons.perm_identity,
            placeholder: 'Name',
            keyboardType: TextInputType.emailAddress,
            controller: _nameCtroller,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            controller: _emailCtroller,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            controller: _passwordCtroller,
            isPassword: true,
          ),
          // TextField(),
          ButtonBlue(
            title: '회원가입',
            onPressed: authService.authenCando
                ? null
                : () async {
                    final registerOK = await authService.register(
                        _nameCtroller.text.trim(),
                        _emailCtroller.text.trim(),
                        _passwordCtroller.text.trim());
                    if (registerOK == true) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'user');
                    } else {
                      mostrarAlerta(
                          context, '회원가입이 실패했습니다.', registerOK.toString());
                    }
                  },
          ),
        ],
      ),
    );
  }
}
