import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:seva_meal/core/utils/user_session.dart';
import 'package:seva_meal/models/user_model.dart';
import 'package:seva_meal/screens/dashboard_screen.dart';
import 'package:seva_meal/providers/user_auth_provider.dart';
import 'package:seva_meal/screens/register_screen.dart';
import 'package:seva_meal/screens/select_role_screen.dart';
import 'package:seva_meal/screens/shared_widgets/custom_button.dart';
import 'package:seva_meal/screens/shared_widgets/custom_text_form_field.dart';
import 'package:seva_meal/screens/shared_widgets/google_widget.dart';
import 'package:seva_meal/screens/shared_widgets/show_snackbar.dart';
import 'package:seva_meal/screens/shared_widgets/upsidedown_clipper.dart';
import 'package:seva_meal/screens/shared_widgets/wave_clip_banner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    callAsyncTask();
  }

  Future<void> callAsyncTask() async {
    await GoogleSignIn.instance.initialize();
  }

  Future<void> loginUser(bool isGoogle, BuildContext context) async {
    final res;
    setState(() {
      isLoading = true;
    });
    if (isGoogle) {
      res = await context.read<UserAuthProvider>().authenticateUserWithGoogle();
    } else {
      if (!formKey.currentState!.validate()) return;
      res = await context.read<UserAuthProvider>().loginWithemailAndPassword(
        userNameController.text,
        passwordController.text,
      );
    }
    print(res);
    res.fold(
      (l) {
        showSnackBar(context, l.message, false);
      },
      (r) async {
        UserModel? user = await UserSession().user;
        print(user);
        if (user == null) return;
        if (user.role.isNotEmpty) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen(role: user.role)),
            (_) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SelectRoleScreen(user: r)),
            (_) => false,
          );
        }
      },
    );

    setState(() {
      isLoading = false;
    });
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
                  children: [
                    WaveClipBanner(isLogoRequired: true),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
                        child: Column(
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),
                            CustomTextFormField(
                              controller: userNameController,
                              label: "Email",
                              inputFormatters: [LengthLimitingTextInputFormatter(50)],
                              borderColor: AppColors.grayMedium,
                              hintText: "Enter email",
                              hintTextColor: AppColors.grayMedium,
                              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                              onValidate: (value) {
                                if (value.isEmpty) {
                                  return "Please enter email id";
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return "Please enter a valid email";
                                }
                              },
                              textInputType: TextInputType.text,
                            ),
                            const SizedBox(height: 24),
                            CustomTextFormField(
                              controller: passwordController,
                              inputFormatters: [LengthLimitingTextInputFormatter(50)],
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
                              textInputType: TextInputType.text,
                            ),

                            const SizedBox(height: 32),
                            CustomButton(
                              text: "Login",
                              onPressed: () {
                                loginUser(false, context);
                              },
                            ),
                            const SizedBox(height: 24),
                            Text("or"),
                            const SizedBox(height: 24),
                            InkWell(
                              onTap: () {
                                loginUser(true, context);
                              },
                              child: GoogleWidget.GoogleWidget(),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                                      (_) => false,
                                    );
                                  },
                                  child: const Text(
                                    "Register",
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
