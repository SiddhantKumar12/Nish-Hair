import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:resolute/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resolute/utils.dart';
import 'custom_field_widget.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginPage({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isHiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, right: 25, left: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/resolute.jpg'),
              CustomTextField(
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
                hintText: 'Enter Your E-mail',
                icon: const Icon(Icons.email),
              ),
              // SizedBox(height: SizeConfig.deviceHeight * 0.032),
              const SizedBox(height: 10),
              CustomTextField(
                textEditingController: _passwordController,
                textInputType: TextInputType.visiblePassword,
                hintText: 'Enter Your Password',
                icon: const Icon(Icons.lock),
                suffixicon: InkWell(
                  onTap: () {
                    setState(() {
                      isHiddenPassword = !isHiddenPassword;
                    });
                  },
                  child: Icon(isHiddenPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                isPass: isHiddenPassword,
              ),
              const Divider(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    primary: Colors.red),
                onPressed: () {
                  signIn();
                },
                icon: const Icon(Icons.lock_open),
                label: const Text('Sign In'),
              ),
              const Divider(),
              RichText(
                text: TextSpan(
                  text: 'Register an account ?? ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: 'Sign Up',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    // TextSpan(text: ' world!'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
