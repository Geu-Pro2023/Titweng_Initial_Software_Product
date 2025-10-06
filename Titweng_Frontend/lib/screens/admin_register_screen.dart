import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:titweng/utils/app_theme.dart';
import 'package:titweng/models/cow_model.dart';
import 'package:titweng/services/mock_service.dart';

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  final _locationController = TextEditingController();
  final _stateController = TextEditingController();
  final _witnessController = TextEditingController();
  final _additionalDetailsController = TextEditingController();
  
  List<File> _noseImages = [];
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _locationController.dispose();
    _stateController.dispose();
    _witnessController.dispose();
    _additionalDetailsController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _noseImages = images.map((image) => File(image.path)).toList();
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick images: $e');
    }
  }

  Future<void> _registerCow() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_noseImages.length < 10) {
      _showErrorDialog('Please upload at least 10 nose print images');
      return;
    }

    if (_noseImages.length > 15) {
      _showErrorDialog('Please upload maximum 15 nose print images');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final cow = CowModel(
        id: 'COW_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        ownerName: _ownerNameController.text.trim(),
        ownerEmail: _ownerEmailController.text.trim(),
        location: _locationController.text.trim(),
        state: _stateController.text.trim(),
        witness: _witnessController.text.trim(),
        noseImagePaths: _noseImages.map((file) => file.path).toList(),
        registrationDate: DateTime.now(),
        additionalDetails: _additionalDetailsController.text.trim(),
      );

      await MockService.instance.registerCow(cow);
      _showSuccessDialog(cow);
    } catch (e) {
      _showErrorDialog('Registration failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(CowModel cow) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.check_circle,
                color: AppTheme.successColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Registration Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cattle "${cow.name}" has been successfully registered.'),
            const SizedBox(height: 8),
            Text('Registration ID: ${cow.id}'),
            const SizedBox(height: 8),
            Text('Owner will be notified: ${cow.ownerEmail}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: const Text('Register Another'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _ageController.clear();
    _ownerNameController.clear();
    _ownerEmailController.clear();
    _locationController.clear();
    _stateController.clear();
    _witnessController.clear();
    _additionalDetailsController.clear();
    setState(() {
      _noseImages.clear();
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppTheme.lightTextColor,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.adminGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Register New Cattle',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Add cattle to the verification system',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideX(begin: -0.3, end: 0),

              // Form
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Cattle Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildTextField(
                            controller: _nameController,
                            label: 'Cattle Name *',
                            icon: Icons.pets,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter cattle name';
                              }
                              return null;
                            },
                          ),

                          _buildTextField(
                            controller: _ageController,
                            label: 'Age (years) *',
                            icon: Icons.calendar_today,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter age';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),

                          Text(
                            'Owner Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _ownerNameController,
                            label: 'Owner Name *',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter owner name';
                              }
                              return null;
                            },
                          ),

                          _buildTextField(
                            controller: _ownerEmailController,
                            label: 'Owner Email *',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter owner email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          _buildTextField(
                            controller: _locationController,
                            label: 'Location *',
                            icon: Icons.location_on,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter location';
                              }
                              return null;
                            },
                          ),

                          _buildTextField(
                            controller: _stateController,
                            label: 'State *',
                            icon: Icons.map,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter state';
                              }
                              return null;
                            },
                          ),

                          _buildTextField(
                            controller: _witnessController,
                            label: 'Witness *',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter witness name';
                              }
                              return null;
                            },
                          ),

                          _buildTextField(
                            controller: _additionalDetailsController,
                            label: 'Additional Details',
                            icon: Icons.notes,
                            maxLines: 3,
                          ),

                          const SizedBox(height: 24),

                          // Nose Images Section
                          Text(
                            'Nose Print Images (10-15 required)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Image Upload Button
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _pickImages,
                              icon: Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                              label: Text(
                                _noseImages.isEmpty 
                                    ? 'Upload Nose Images' 
                                    : '${_noseImages.length} images selected',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),

                          // Image Preview
                          if (_noseImages.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _noseImages.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: FileImage(_noseImages[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Register Button
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppTheme.primaryGradient,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _registerCow,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Register Cattle',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().slideY(begin: 0.3, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }
}