import 'dart:io';

import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/core/utils/user_session.dart';
import 'package:seva_meal/db/shared_prefs.dart';
import 'package:seva_meal/models/post_model.dart';
import 'package:seva_meal/models/user_model.dart';
import 'package:seva_meal/providers/donor_provider.dart';
import 'package:seva_meal/screens/shared_widgets/custom_button.dart';
import 'package:seva_meal/screens/shared_widgets/custom_dropdown_widget.dart';
import 'package:seva_meal/screens/shared_widgets/custom_text_form_field.dart';
import 'package:seva_meal/screens/shared_widgets/loader.dart';
import 'package:seva_meal/screens/shared_widgets/show_snackbar.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:seva_meal/services/fcm_service.dart';
import 'package:seva_meal/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonorCreateScreen extends StatefulWidget {
  const DonorCreateScreen({super.key});

  @override
  State<DonorCreateScreen> createState() => _DonorCreateScreenState();
}

class _DonorCreateScreenState extends State<DonorCreateScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController foodTypeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController pickupAddressController = TextEditingController();
  bool isLoading = false;
  File? capturedImage;
  String? selectedImageUrl;
  String? selectedRegion;
  String? selectedCity;

  List<String> dropdownList = [
    "Cooked",
    "Raw Vegetables",
    "Bakery",
    "Fruits",
    "Dairy",
    "Packaged",
    "other",
  ];

  void upload(File file) async {
    final cloudinary = CloudinaryPublic('detlktkvo', 'ml_default', cache: false);

    final response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        file.path,
        resourceType: CloudinaryResourceType.Image,
        folder: "sevameal",
      ),
    );
    print("Upload success: $response");
    setState(() {
      capturedImage = file;
      selectedImageUrl = response.secureUrl;
    });
  }

  Future<void> captureImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 400,
      maxHeight: 600,
      imageQuality: 70,
    );

    if (photo != null) {
      upload(File(photo.path));
    } else {
      showSnackBar(context, "Image not captured", false);
    }
  }

  Future<void> submitDetails() async {
    String token = await SharedPrefs().getFcmToken();
    print(token);
    NotificationService.sendToUser(token: token, title: 'hii', body: 'i am donor');

    return;
    if (formKey.currentState!.validate()) {}
    if (selectedImageUrl == null) return showSnackBar(context, "Please upload an image", false);
    if (selectedCity == null) return showSnackBar(context, "Please select a city", false);
    if (selectedRegion == null) return showSnackBar(context, "Please select a region", false);

    UserModel? user = UserSession().user;
    if (user == null) return showSnackBar(context, "Failed to get user id", false);

    PostModel postModel = PostModel(
      title: titleController.text,
      description: descriptionController.text,
      foodType: foodTypeController.text,
      quantity: quantityController.text,
      city: selectedCity ?? '',
      region: selectedRegion ?? '',
      donorId: user.id,
      pickupAddress: pickupAddressController.text,
      pickupFoodPictureUrl: selectedImageUrl ?? '',
      status: Constants.STATUS_PENDING,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );

    setState(() => isLoading = true);

    final res = await context.read<DonorProvider>().createPost(postModel);

    res.fold((l) => showSnackBar(context, l.message, false), (r) {
      setState(() {
        capturedImage = null;
        selectedImageUrl = null;
        selectedCity = null;
        selectedRegion = null;
        titleController.clear();
        descriptionController.clear();
        foodTypeController.clear();
        quantityController.clear();
        pickupAddressController.clear();
      });
      showSnackBar(context, r, true);
    });
    setState(() => isLoading = false);
  }

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
                  child: Form(
                    key: formKey,
                    child: Column(
                      spacing: 16,
                      children: [
                        CustomTextFormField(
                          controller: titleController,
                          label: "Food Title",
                          hintText: "Enter food title",
                          inputFormatters: [LengthLimitingTextInputFormatter(100)],
                          onValidate: (value) {
                            if (value.isEmpty) {
                              return "Please enter a title";
                            }
                            return null;
                          },
                          textInputType: TextInputType.text,
                        ),
                        CustomTextFormField(
                          controller: descriptionController,
                          label: "Description",
                          hintText: "Daal rice",
                          inputFormatters: [LengthLimitingTextInputFormatter(400)],
                          onValidate: (value) {
                            if (value.isEmpty) {
                              return "Please enter a description";
                            }
                            return null;
                          },
                          textInputType: TextInputType.text,
                        ),
                        CustomTextFormField(
                          controller: quantityController,
                          label: "Quantity",
                          hintText: "Enter quantity",
                          inputFormatters: [LengthLimitingTextInputFormatter(8)],
                          onValidate: (value) {
                            if (value.isEmpty) {
                              return "Please enter a quantity";
                            }
                            return null;
                          },
                          textInputType: TextInputType.number,
                        ),
                        CustomDropdownWidget(
                          dropdownList: dropdownList,
                          hintText: "Select food type",
                          icon: Icons.food_bank,
                          onSelected: (value) {
                            setState(() {
                              foodTypeController.text = value;
                            });
                          },
                          itemToString: (item) => item,
                        ),

                        CustomDropdownWidget(
                          dropdownList: Constants.regionList.keys.toList(),
                          hintText: 'Select city',
                          icon: Icons.location_city,
                          onSelected: (value) {
                            setState(() {
                              selectedCity = value;
                            });
                          },
                          itemToString: (item) => item,
                        ),
                        CustomDropdownWidget(
                          dropdownList: selectedCity == null
                              ? []
                              : Constants.regionList[selectedCity]!,
                          hintText: 'Select region',
                          icon: Icons.location_city,
                          onSelected: (value) {
                            setState(() {
                              selectedRegion = value;
                            });
                          },
                          itemToString: (item) => item,
                        ),
                        CustomTextFormField(
                          controller: pickupAddressController,
                          label: "Pickup address",
                          hintText: "Enter pickup address",
                          inputFormatters: [],
                          onValidate: (value) {},
                          textInputType: TextInputType.text,
                        ),
                        InkWell(
                          onTap: () {
                            captureImage();
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.grayLight, width: 1.0),
                            ),
                            child: capturedImage != null
                                ? Image.file(capturedImage!, fit: BoxFit.cover)
                                : Column(
                                    spacing: 8,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upload, size: 50, color: AppColors.grayLight),
                                      Text(
                                        "Upload Image",
                                        style: TextStyle(color: AppColors.grayDark),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        isLoading
                            ? Loader()
                            : CustomButton(
                                text: "Create Post",
                                onPressed: () {
                                  submitDetails();
                                },
                              ),
                      ],
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
}
