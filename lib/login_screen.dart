import 'package:flutter/services.dart';
import 'package:seva_meal/core/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:seva_meal/shared_widgets/custom_button.dart';
import 'package:seva_meal/shared_widgets/custom_text_form_field.dart';
import 'package:seva_meal/shared_widgets/google_widget.dart';
import 'package:seva_meal/shared_widgets/upsidedown_clipper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.33,
                        color: const Color.fromARGB(255, 218, 237, 255),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/app_logo.png', height: 130),
                            SizedBox(height: 12),
                            Text(
                              'Food that carries kindness',
                              style: TextStyle(
                                color: Color(0xff0D2A3C),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 50), // padding so wave doesn't cut text
                          ],
                        ),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
                        child: Column(
                          children: [
                            // SizedBox(
                            //   width: double.infinity,
                            // child:
                            Text(
                              "Login",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            // ),
                            SizedBox(height: 12),
                            CustomTextFormField(
                              controller: userNameController,
                              label: "Username",
                              inputFormatters: [
                                FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: true),
                                LengthLimitingTextInputFormatter(50),
                              ],
                              borderColor: AppColors.grayMedium,
                              hintText: "Enter Username",
                              hintTextColor: AppColors.grayMedium,
                              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                              onValidate: (value) {
                                if (value.isEmpty) {
                                  return "Please enter username";
                                }
                              },
                              textInputType: TextInputType.number,
                            ),
                            const SizedBox(height: 24),
                            CustomTextFormField(
                              controller: passwordController,
                              inputFormatters: [
                                FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: true),
                                LengthLimitingTextInputFormatter(50),
                              ],
                              label: "Password",
                              hintText: "Enter Password",
                              obscureText: true,
                              hintTextColor: AppColors.grayMedium,
                              borderColor: AppColors.grayMedium,
                              prefixIcon: const Icon(Icons.lock, color: AppColors.primaryDeepest),
                              onValidate: (value) {
                                if (value.isEmpty) {
                                  return "Please enter password";
                                }
                              },
                              textInputType: TextInputType.number,
                            ),

                            const SizedBox(height: 32),
                            CustomButton(text: "Login", onPressed: () {}),
                            const SizedBox(height: 24),
                            Text("or"),
                            const SizedBox(height: 24),
                            GoogleWidget.GoogleWidget(),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account?"),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Sign up",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
