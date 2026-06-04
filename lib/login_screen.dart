import 'package:flutter/services.dart';
import 'package:seva_meal/core/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:seva_meal/shared_widgets/custom_button.dart';
import 'package:seva_meal/shared_widgets/custom_text_form_field.dart';

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
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                      Image.asset('assets_hk/hk_logo.png', width: 200, height: 200),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
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
                              prefixIcon: const Icon(
                                Icons.person,
                                color: AppColors.oldprimaryDeepest,
                              ),
                              onValidate: (value) {
                                if (value.isEmpty) {
                                  return "Please enter username";
                                }
                              },
                              textInputType: TextInputType.number,
                            ),
                            const SizedBox(height: 32),
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

                            const SizedBox(height: 48),
                            CustomButton(text: "Login", onPressed: () {}),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
