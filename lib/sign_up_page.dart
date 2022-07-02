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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isHiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    const color = const Color(0xFF33CCC5);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                child: Image.asset(
                  'assets/images/pic.png',
                  height: double.maxFinite,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: MediaQuery.of(context).size.height * 0.50,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.04,
              right: MediaQuery.of(context).size.height * 0.04,
              bottom: MediaQuery.of(context).size.height * 0.07,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height * 0.58,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Sign Up to Continue',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: color),
                        ),
                        CustomTextField(
                          textEditingController: _emailController,
                          textInputType: TextInputType.emailAddress,
                          hintText: 'Enter E-mail',
                          icon: const Icon(Icons.email),
                        ),
                        CustomTextField(
                          validator: (value) =>
                              value != null && value.length < 8
                                  ? 'Enter min. 8 characters'
                                  : null,
                          textEditingController: _passwordController,
                          textInputType: TextInputType.visiblePassword,
                          hintText: 'Password',
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
                        CustomTextField(
                          validator: (value) =>
                              value != null && value.length < 8
                                  ? 'Enter min. 8 characters'
                                  : null,
                          textEditingController: _confirmPasswordController,
                          textInputType: TextInputType.visiblePassword,
                          hintText: 'Confirm Password',
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
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'Forget Password?',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.22,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                primary: color),
                            onPressed: () {
                              signUp();
                            },
                            icon: const Icon(Icons.lock_open),
                            label: const Text('Sign Up'),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Already have an account ',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = widget.onClickedSignUp,
                                  text: 'Sign In',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: color)),
                              // TextSpan(text: ' world!'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
