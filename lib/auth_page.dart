import 'package:flutter/cupertino.dart';
import 'package:resolute/login_page.dart';
import 'package:resolute/sign_up_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginPage(onClickedSignUp: toggle)
        : SignUpPage(
            onClickedSignUp: toggle,
          );
  }

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
