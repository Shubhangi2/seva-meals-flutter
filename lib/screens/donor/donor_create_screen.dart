import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/screens/shared_widgets/custom_button.dart';
import 'package:seva_meal/screens/shared_widgets/custom_dropdown_widget.dart';
import 'package:seva_meal/screens/shared_widgets/custom_text_form_field.dart';

class DonorCreateScreen extends StatefulWidget {
  const DonorCreateScreen({super.key});

  @override
  State<DonorCreateScreen> createState() => _DonorCreateScreenState();
}

class _DonorCreateScreenState extends State<DonorCreateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController foodTypeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();

  List<String> dropdownList = [
    "Cooked",
    "Raw Vegetables",
    "Bakery",
    "Fruits",
    "Dairy",
    "Packaged",
    "other",
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: AppColors.primary,
              width: double.infinity,
              child: Image.asset(
                'assets/create_post_bg.jpg',
                height: 180,
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(.2),
              ),
            ),
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Create Donation Post",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 150),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16,
                    children: [
                      CustomTextFormField(
                        controller: titleController,
                        label: "Food Title",
                        hintText: "Enter food title",
                        inputFormatters: [],
                        onValidate: (value) {},
                        textInputType: TextInputType.text,
                      ),
                      CustomTextFormField(
                        controller: descriptionController,
                        label: "Description",
                        hintText: "Daal rice",
                        inputFormatters: [],
                        onValidate: (value) {},
                        textInputType: TextInputType.text,
                      ),
                      CustomDropdownWidget(
                        dropdownList: dropdownList,
                        hintText: "Select food type",
                        icon: Icons.food_bank,
                        onSelected: (value) {},
                        itemToString: (item) => item,
                      ),
                      CustomTextFormField(
                        controller: areaController,
                        label: "Area",
                        hintText: "Enter area",
                        inputFormatters: [],
                        onValidate: (value) {},
                        textInputType: TextInputType.text,
                      ),
                      CustomTextFormField(
                        controller: quantityController,
                        label: "Pickup address",
                        hintText: "Enter pickup address",
                        inputFormatters: [],
                        onValidate: (value) {},
                        textInputType: TextInputType.text,
                      ),
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.grayLight, width: 1.0),
                        ),
                        child: Column(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, size: 50, color: AppColors.grayLight),
                            Text("Upload Image", style: TextStyle(color: AppColors.grayDark)),
                          ],
                        ),
                      ),
                      // CustomTextFormField(
                      //   controller: areaController,
                      //   label: "",
                      //   hintText: "Enter area",
                      //   inputFormatters: [],
                      //   onValidate: (value) {},
                      //   textInputType: TextInputType.text,
                      // ),
                      CustomButton(text: "Create Post", onPressed: () {}),
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
