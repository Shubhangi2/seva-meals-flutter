import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/models/user_model.dart';
import 'package:seva_meal/providers/user_auth_provider.dart';
import 'package:seva_meal/screens/shared_widgets/custom_dropdown_widget.dart';
import 'package:seva_meal/screens/shared_widgets/custom_text_form_field.dart';
import 'package:seva_meal/screens/shared_widgets/show_snackbar.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late final TextEditingController _fullNameController;
  late final TextEditingController _mobileNoController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _mobileNoController = TextEditingController(text: widget.user.mobileNo);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileNoController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  Future<void> _saveChanges(String selectedCity, String selectedRegion) async {
    if (!_formKey.currentState!.validate()) return;

    UserModel user = UserModel(
      id: widget.user.id,
      role: widget.user.role,
      fullName: _fullNameController.text,
      mobileNo: _mobileNoController.text,
      email: _emailController.text,
      city: selectedCity,
      fcmToken: widget.user.fcmToken,
      region: selectedRegion,
    );
    if (user == widget.user) return showSnackBar(context, "No changes made", false);
    setState(() => _isSaving = true);
    final res = await context.read<UserAuthProvider>().editUser(user);
    res.fold((l) => showSnackBar(context, l.message, false), (_) {
      showSnackBar(context, "Profile updated successfully", true);
      Navigator.pop(context);
    });

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    String selectedCity = widget.user.city;
    String selectedRegion = widget.user.region;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        appBar: AppBar(
          toolbarHeight: 46,
          backgroundColor: AppColors.primaryDeep,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Avatar ──────────────────────────────────────────
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primaryLight, width: 2.5),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/profile.png',
                                  height: 96,
                                  width: 96,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      _sectionLabel('Personal Info'),
                      const SizedBox(height: 12),

                      CustomTextFormField(
                        label: 'Full Name',
                        controller: _fullNameController,
                        prefixIcon: Icon(Icons.person_outline_rounded),
                        hintText: 'Enter your full name',
                        textInputType: TextInputType.text,
                        onValidate: (v) => (v.trim().isEmpty) ? 'Mobile number is required' : null,
                        inputFormatters: [LengthLimitingTextInputFormatter(100)],
                      ),
                      const SizedBox(height: 14),

                      CustomTextFormField(
                        label: 'Mobile Number',
                        controller: _mobileNoController,
                        prefixIcon: Icon(Icons.phone_outlined),
                        hintText: 'Enter your mobile number',
                        textInputType: TextInputType.phone,
                        onValidate: (v) => null,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      ),
                      const SizedBox(height: 14),

                      CustomTextFormField(
                        controller: _emailController,
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

                      const SizedBox(height: 28),

                      _sectionLabel('Location'),
                      const SizedBox(height: 12),

                      _sectionLabel('City'),
                      const SizedBox(height: 8),
                      CustomDropdownWidget(
                        initialSelection: selectedCity,
                        dropdownList: Constants.regionList.keys.toList(),
                        hintText: 'Select your city',
                        icon: Icons.location_city_rounded,
                        onSelected: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                        itemToString: (item) => item,
                      ),

                      const SizedBox(height: 20),

                      _sectionLabel('Area / Region'),
                      const SizedBox(height: 8),
                      CustomDropdownWidget(
                        initialSelection: selectedRegion,
                        dropdownList: Constants.regionList[selectedCity]!,
                        hintText: 'Select your area',
                        icon: Icons.map_rounded,
                        onSelected: (value) {
                          setState(() => selectedRegion = value);
                        },
                        itemToString: (item) => item,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // ── Save button pinned at bottom ─────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () => _saveChanges(selectedCity, selectedRegion),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDeep,
                    disabledBackgroundColor: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.bold),
    );
  }
}
