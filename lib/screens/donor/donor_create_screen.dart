import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seva_meal/core/app_colors.dart';
import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/core/utils/user_session.dart';
import 'package:seva_meal/models/post_model.dart';
import 'package:seva_meal/models/user_model.dart';
import 'package:seva_meal/providers/donor_provider.dart';
import 'package:seva_meal/screens/shared_widgets/custom_button.dart';
import 'package:seva_meal/screens/shared_widgets/custom_dropdown_widget.dart';
import 'package:seva_meal/screens/shared_widgets/custom_text_form_field.dart';
import 'package:seva_meal/screens/shared_widgets/loader.dart';
import 'package:seva_meal/screens/shared_widgets/show_snackbar.dart';
import 'package:seva_meal/services/notification_service.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class DonorCreateScreen extends StatefulWidget {
  const DonorCreateScreen({super.key});

  @override
  State<DonorCreateScreen> createState() => _DonorCreateScreenState();
}

class _DonorCreateScreenState extends State<DonorCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _pickupAddressController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  bool _isLoading = false;
  bool _isUploading = false;
  bool _isVeg = true;
  File? _capturedImage;
  String? _selectedImageUrl;
  String? _selectedRegion;
  String? _selectedCity;
  String? _selectedFoodType;
  String? _selectedExpiry;
  List<UserModel> _volunteers = [];

  final List<String> _foodTypes = [
    "Cooked Food",
    "Raw Vegetables",
    "Bakery",
    "Fruits",
    "Dairy",
    "Packaged",
    "Other",
  ];

  final List<String> _expiryOptions = ["1 hour", "2 hours", "4 hours", "6 hours", "Next morning"];

  @override
  void initState() {
    super.initState();
    _loadVolunteers();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _pickupAddressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _loadVolunteers() async {
    final user = UserSession().user;
    if (user == null) return;
    final res = await context.read<DonorProvider>().getNearbyVolunteers(user.region);
    res.fold((l) => print(l.message), (r) => setState(() => _volunteers = r));
  }

  Future<void> _uploadImage(File file) async {
    setState(() => _isUploading = true);
    try {
      final cloudinary = CloudinaryPublic('detlktkvo', 'ml_default', cache: false);
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Image,
          folder: "sevameal",
        ),
      );
      setState(() {
        _capturedImage = file;
        _selectedImageUrl = response.secureUrl;
      });
    } catch (e) {
      showSnackBar(context, "Image upload failed. Try again.", false);
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(
      source: source,
      maxWidth: 400,
      maxHeight: 600,
      imageQuality: 70,
    );
    if (photo != null) {
      await _uploadImage(File(photo.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Food Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Help volunteers identify your food quickly',
                style: TextStyle(fontSize: 12, color: AppColors.primaryLight),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _imageSourceTile(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _imageSourceTile(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSourceTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryLightest),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  void _sendNotificationsToVolunteers() {
    for (final volunteer in _volunteers) {
      NotificationService.sendToUser(
        token: volunteer.fcmToken,
        title: '🍱 New donation nearby!',
        body:
            '${_titleController.text} available in ${"$_selectedRegion, $_selectedCity"}. Pick it up before it expires!',
        data: {'type': 'new_donation'},
      );
    }
  }

  Future<void> _submitPost() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedFoodType == null) {
      return showSnackBar(context, "Please select food type", false);
    }
    if (_selectedCity == null) {
      return showSnackBar(context, "Please select a city", false);
    }
    if (_selectedRegion == null) {
      return showSnackBar(context, "Please select a region", false);
    }
    if (_selectedExpiry == null) {
      return showSnackBar(context, "Please select expiry time", false);
    }
    if (_selectedImageUrl == null) {
      return showSnackBar(context, "Please upload a food photo", false);
    }

    final user = UserSession().user;
    if (user == null) {
      return showSnackBar(context, "Session expired. Please login again.", false);
    }

    final post = PostModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      foodType: _selectedFoodType ?? '',
      quantity: _quantityController.text.trim(),
      city: _selectedCity ?? '',
      region: _selectedRegion ?? '',
      donorId: user.id,
      pickupAddress: _pickupAddressController.text.trim(),
      pickupFoodPictureUrl: _selectedImageUrl ?? '',
      status: Constants.STATUS_PENDING,
      isActive: true,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );

    setState(() => _isLoading = true);

    final res = await context.read<DonorProvider>().createPost(post);

    res.fold((l) => showSnackBar(context, l.message, false), (r) {
      _resetForm();
      showSnackBar(context, r, true);
      _sendNotificationsToVolunteers();
    });

    setState(() => _isLoading = false);
  }

  void _resetForm() {
    setState(() {
      _capturedImage = null;
      _selectedImageUrl = null;
      _selectedCity = null;
      _selectedRegion = null;
      _selectedFoodType = null;
      _selectedExpiry = null;
      _isVeg = true;
    });
    _titleController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _pickupAddressController.clear();
    _instructionsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── SECTION: Food Details ──
                      _buildSectionLabel('Food Details', Icons.fastfood_rounded),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        controller: _titleController,
                        label: "Food Title",
                        hintText: "e.g. Biryani, Dal Rice + Sabzi",
                        inputFormatters: [LengthLimitingTextInputFormatter(100)],
                        onValidate: (value) => value.isEmpty ? "Please enter a title" : null,
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        controller: _descriptionController,
                        label: "Description",
                        hintText: "Ingredients, allergens, packaging notes...",
                        inputFormatters: [LengthLimitingTextInputFormatter(400)],
                        onValidate: (value) => value.isEmpty ? "Please enter a description" : null,
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(height: 12),

                      // food type + quantity row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomDropdownWidget(
                              dropdownList: _foodTypes,
                              hintText: "Food type",
                              icon: Icons.category_rounded,
                              onSelected: (value) => setState(() => _selectedFoodType = value),
                              itemToString: (item) => item,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: CustomTextFormField(
                              controller: _quantityController,
                              label: "Qty (portions)",
                              hintText: "e.g. 40",
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onValidate: (value) => value.isEmpty ? "Required" : null,
                              textInputType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // veg / non-veg toggle
                      _buildVegToggle(),
                      const SizedBox(height: 20),

                      // ── SECTION: Expiry ──
                      _buildSectionLabel('Expiry Time', Icons.access_time_rounded),
                      const SizedBox(height: 12),
                      CustomDropdownWidget(
                        dropdownList: _expiryOptions,
                        hintText: "How long is the food good for?",
                        icon: Icons.timer_rounded,
                        onSelected: (value) => setState(() => _selectedExpiry = value),
                        itemToString: (item) => item,
                      ),
                      const SizedBox(height: 20),

                      // ── SECTION: Location ──
                      _buildSectionLabel('Pickup Location', Icons.location_on_rounded),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomDropdownWidget(
                              dropdownList: Constants.regionList.keys.toList(),
                              hintText: 'City',
                              icon: Icons.location_city_rounded,
                              onSelected: (value) => setState(() {
                                _selectedCity = value;
                                _selectedRegion = null;
                              }),
                              itemToString: (item) => item,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: _selectedCity == null ? 0.4 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: IgnorePointer(
                                ignoring: _selectedCity == null,
                                child: CustomDropdownWidget(
                                  dropdownList: _selectedCity == null
                                      ? []
                                      : Constants.regionList[_selectedCity]!,
                                  hintText: 'Area',
                                  icon: Icons.map_rounded,
                                  onSelected: (value) => setState(() => _selectedRegion = value),
                                  itemToString: (item) => item,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        controller: _pickupAddressController,
                        label: "Full Pickup Address",
                        hintText: "Building name, street, landmark",
                        inputFormatters: [],
                        onValidate: (value) => value.isEmpty ? "Please enter pickup address" : null,
                        textInputType: TextInputType.streetAddress,
                      ),
                      const SizedBox(height: 20),

                      // ── SECTION: Special instructions ──
                      _buildSectionLabel('Special Instructions', Icons.info_outline_rounded),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        controller: _instructionsController,
                        label: "Instructions (optional)",
                        hintText: "e.g. Bring containers, call on arrival, gate code",
                        inputFormatters: [LengthLimitingTextInputFormatter(200)],
                        onValidate: (_) => null,
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),

                      // ── SECTION: Food Photo ──
                      _buildSectionLabel('Food Photo', Icons.photo_camera_rounded),
                      const SizedBox(height: 12),
                      _buildImagePicker(),
                      const SizedBox(height: 20),

                      // ── SAFETY CONSENT ──
                      _buildSafetyConsent(),
                      const SizedBox(height: 24),

                      // ── SUBMIT ──
                      _isLoading
                          ? const Loader()
                          : CustomButton(text: "Post Donation", onPressed: _submitPost),
                      const SizedBox(height: 20),
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

  // ─── HEADER ───
  Widget _buildHeader() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_rounded, color: AppColors.primaryLightest),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Post Donation',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                'Fill details — volunteers will be notified',
                style: TextStyle(color: AppColors.primaryLightest.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── SECTION LABEL ───
  Widget _buildSectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.primaryLight),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDeep,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ─── VEG TOGGLE ───
  Widget _buildVegToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLightest),
      ),
      child: Row(
        children: [
          Expanded(child: _vegOption(true, '🌿 Vegetarian')),
          Expanded(child: _vegOption(false, '🍗 Non-Veg')),
        ],
      ),
    );
  }

  Widget _vegOption(bool isVeg, String label) {
    final selected = _isVeg == isVeg;
    return GestureDetector(
      onTap: () => setState(() => _isVeg = isVeg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : AppColors.primaryLight,
            ),
          ),
        ),
      ),
    );
  }

  // ─── IMAGE PICKER ───
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _showImageSourceSheet,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _selectedImageUrl != null ? AppColors.primaryLight : AppColors.primaryLightest,
            width: _selectedImageUrl != null ? 1.5 : 1,
          ),
        ),
        child: _isUploading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryLight, strokeWidth: 2),
                  const SizedBox(height: 10),
                  Text(
                    'Uploading...',
                    style: TextStyle(fontSize: 12, color: AppColors.primaryLight),
                  ),
                ],
              )
            : _capturedImage != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.file(_capturedImage!, fit: BoxFit.cover),
                  ),
                  // change photo button
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_rounded, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Change',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_photo_alternate_rounded,
                      color: AppColors.primaryLight,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Add food photo',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryDeep,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Helps volunteers identify food quickly',
                    style: TextStyle(fontSize: 11, color: AppColors.primaryLight),
                  ),
                ],
              ),
      ),
    );
  }

  // ─── SAFETY CONSENT ───
  Widget _buildSafetyConsent() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'By posting this donation I confirm that the food is safe for consumption, properly stored, and accurately described.',
              style: TextStyle(fontSize: 12, color: const Color(0xFF5D4037), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
