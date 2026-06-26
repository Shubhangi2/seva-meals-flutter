import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late final TextEditingController _fullNameController;
  late final TextEditingController _mobileNoController;
  late final TextEditingController _emailController;
  late final TextEditingController _cityController;
  late final TextEditingController _regionController;

  @override
  void initState() {
    super.initState();
    // Replace with actual UserSession().user values
    _fullNameController = TextEditingController(text: 'John Doe');
    _mobileNoController = TextEditingController(text: '+91 98765 43210');
    _emailController = TextEditingController(text: 'john.doe@email.com');
    _cityController = TextEditingController(text: 'Mumbai');
    _regionController = TextEditingController(text: 'Maharashtra');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileNoController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // TODO: Call your update API / provider here
    await Future.delayed(const Duration(seconds: 1)); // simulated delay

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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

                      // ── Personal Info section ────────────────────────────
                      _sectionLabel('Personal Info'),
                      const SizedBox(height: 12),

                      _buildField(
                        label: 'Full Name',
                        controller: _fullNameController,
                        icon: Icons.person_outline_rounded,
                        hint: 'Enter your full name',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
                      ),
                      const SizedBox(height: 14),

                      _buildField(
                        label: 'Mobile Number',
                        controller: _mobileNoController,
                        icon: Icons.phone_outlined,
                        hint: 'Enter your mobile number',
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Mobile number is required' : null,
                      ),
                      const SizedBox(height: 14),

                      _buildField(
                        label: 'Email Address',
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Email is required';
                          final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$');
                          if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      // ── Location section ─────────────────────────────────
                      _sectionLabel('Location'),
                      const SizedBox(height: 12),

                      _buildField(
                        label: 'City',
                        controller: _cityController,
                        icon: Icons.location_city_outlined,
                        hint: 'Enter your city',
                      ),
                      const SizedBox(height: 14),

                      _buildField(
                        label: 'Region / State',
                        controller: _regionController,
                        icon: Icons.location_on_outlined,
                        hint: 'Enter your region or state',
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
                  onPressed: _isSaving ? null : _saveChanges,
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.grayDarkest),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(fontSize: 14, color: AppColors.grayDarkest, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.grayBrightest, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.grayBrightest, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
