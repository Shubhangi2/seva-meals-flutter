import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/db/shared_prefs.dart';
import 'package:seva_meal/models/user_model.dart';
import 'package:seva_meal/providers/user_auth_provider.dart';
import 'package:seva_meal/screens/dashboard_screen.dart';
import 'package:seva_meal/screens/shared_widgets/custom_dropdown_widget.dart';
import 'package:seva_meal/screens/shared_widgets/show_snackbar.dart';
import 'package:seva_meal/screens/shared_widgets/wave_clip_banner.dart';

class SelectCityScreen extends StatefulWidget {
  final UserModel user;
  const SelectCityScreen({super.key, required this.user});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  String? selectedCity;
  String? selectedRegion;

  void submitDetails(BuildContext context) {
    if (selectedCity == null) return showSnackBar(context, "Please select a city", false);
    if (selectedRegion == null) return showSnackBar(context, "Please select a region", false);
    widget.user.city = selectedCity ?? '';
    widget.user.region = selectedRegion ?? '';
    context.read<UserAuthProvider>().saveUserDetails(widget.user);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen(role: widget.user.role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          Image.asset('assets/city.png', height: 300),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // title
                  Text(
                    'Where are you based?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'We use this to show you nearby donations and volunteers in your area.',
                    style: TextStyle(fontSize: 13, color: AppColors.primaryLight, height: 1.5),
                  ),

                  const SizedBox(height: 20),

                  _buildLabel('City', Icons.location_city_rounded),
                  const SizedBox(height: 8),
                  CustomDropdownWidget(
                    dropdownList: Constants.regionList.keys.toList(),
                    hintText: 'Select your city',
                    icon: Icons.location_city_rounded,
                    onSelected: (value) {
                      setState(() {
                        selectedCity = value;
                        selectedRegion = null;
                      });
                    },
                    itemToString: (item) => item,
                  ),

                  const SizedBox(height: 20),

                  _buildLabel('Area / Region', Icons.map_rounded),
                  const SizedBox(height: 8),

                  AnimatedOpacity(
                    opacity: selectedCity == null ? 0.4 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: selectedCity == null,
                      child: CustomDropdownWidget(
                        dropdownList: selectedCity == null
                            ? []
                            : Constants.regionList[selectedCity]!,
                        hintText: selectedCity == null ? 'Select city first' : 'Select your area',
                        icon: Icons.map_rounded,
                        onSelected: (value) {
                          setState(() => selectedRegion = value);
                        },
                        itemToString: (item) => item,
                      ),
                    ),
                  ),

                  if (selectedCity != null && selectedRegion != null) ...[
                    const SizedBox(height: 24),
                    _buildSummaryCard(),
                  ],

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedCity != null && selectedRegion != null
                          ? () {
                              submitDetails(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primaryLightest,
                        disabledForegroundColor: AppColors.primaryLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm Location',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.primaryLight),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryDeep),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLightest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLightest),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$selectedCity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$selectedRegion',
                style: TextStyle(fontSize: 12, color: AppColors.primaryLight),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.location_on_rounded, color: AppColors.primaryLight, size: 18),
        ],
      ),
    );
  }
}
