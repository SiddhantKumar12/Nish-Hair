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
                  child: SingleChildScrollView(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Sign In to Continue',
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
                                signIn();
                              },
                              icon: const Icon(Icons.lock_open),
                              label: const Text('Sign In'),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Register an account ?? ',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = widget.onClickedSignUp,
                                    text: 'Sign Up',
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
        )
        // Padding(
        //   padding: const EdgeInsets.only(top: 50, right: 25, left: 25),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Image.asset('assets/images/pic.png'),
        //       CustomTextField(
        //         textEditingController: _emailController,
        //         textInputType: TextInputType.emailAddress,
        //         hintText: 'Enter E-mail',
        //         icon: const Icon(Icons.email),
        //       ),
        //       // SizedBox(height: SizeConfig.deviceHeight * 0.032),
        //       const SizedBox(height: 10),
        //       CustomTextField(
        //         textEditingController: _passwordController,
        //         textInputType: TextInputType.visiblePassword,
        //         hintText: 'Password',
        //         icon: const Icon(Icons.lock),
        //         suffixicon: InkWell(
        //           onTap: () {
        //             setState(() {
        //               isHiddenPassword = !isHiddenPassword;
        //             });
        //           },
        //           child: Icon(isHiddenPassword
        //               ? Icons.visibility
        //               : Icons.visibility_off),
        //         ),
        //         isPass: isHiddenPassword,
        //       ),
        //       const Divider(),
        //       ElevatedButton.icon(
        //         style: ElevatedButton.styleFrom(
        //             minimumSize: const Size.fromHeight(50),
        //             primary: Colors.red),
        //         onPressed: () {
        //           signIn();
        //         },
        //         icon: const Icon(Icons.lock_open),
        //         label: const Text('Login In'),
        //       ),
        //       const Divider(),
        //       RichText(
        //         text: TextSpan(
        //           text: 'Register an account ?? ',
        //           style: const TextStyle(fontSize: 16, color: Colors.black),
        //           children: <TextSpan>[
        //             TextSpan(
        //                 recognizer: TapGestureRecognizer()
        //                   ..onTap = widget.onClickedSignUp,
        //                 text: 'Sign Up',
        //                 style: const TextStyle(
        //                     fontWeight: FontWeight.bold, color: Colors.red)),
        //             // TextSpan(text: ' world!'),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

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
