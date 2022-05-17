import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:resolute/utils.dart';
import 'custom_field_widget.dart';
import 'main.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const SignUpPage({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
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
          child: Form(
            key: formKey,
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
                const SizedBox(height: 10),
                CustomTextField(
                  validator: (value) => value != null && value.length < 8
                      ? 'Enter min. 8 characters'
                      : null,
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
                // InkWell(
                //   child: Container(
                //     alignment: Alignment.centerRight,
                //     child: Text(
                //       'Forget Password?',
                //       style: TextStyle(color: Colors.blue),
                //     ),
                //   ),
                // ),
                const Divider(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: Colors.red),
                  onPressed: () {
                    signUp();
                  },
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Sign UP'),
                ),
                const Divider(),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account ',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignUp,
                          text: 'Sign In',
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
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
