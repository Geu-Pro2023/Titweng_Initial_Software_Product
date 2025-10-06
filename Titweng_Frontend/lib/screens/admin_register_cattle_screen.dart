import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:titweng/utils/app_theme.dart';
import 'package:titweng/models/cow_model.dart';
import 'package:titweng/services/mock_service.dart';

class AdminRegisterCattleScreen extends StatefulWidget {
  const AdminRegisterCattleScreen({super.key});

  @override
  State<AdminRegisterCattleScreen> createState() => _AdminRegisterCattleScreenState();
}

class _AdminRegisterCattleScreenState extends State<AdminRegisterCattleScreen> {
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

      // Register cow
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
        title: const Text('Registration Successful'),
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
              Navigator.pop(context); // Go back to admin dashboard
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Cattle'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Cattle Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Cattle Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Cattle Name *',
                      prefixIcon: const Icon(Icons.pets),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cattle name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Age
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age (years) *',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                  const SizedBox(height: 24),

                  Text(
                    'Owner Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Owner Name
                  TextFormField(
                    controller: _ownerNameController,
                    decoration: InputDecoration(
                      labelText: 'Owner Name *',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter owner name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Owner Email
                  TextFormField(
                    controller: _ownerEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Owner Email *',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                  const SizedBox(height: 16),

                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location *',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // State
                  TextFormField(
                    controller: _stateController,
                    decoration: InputDecoration(
                      labelText: 'State *',
                      prefixIcon: const Icon(Icons.map),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter state';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Witness
                  TextFormField(
                    controller: _witnessController,
                    decoration: InputDecoration(
                      labelText: 'Witness *',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter witness name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Additional Details
                  TextFormField(
                    controller: _additionalDetailsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Additional Details',
                      prefixIcon: const Icon(Icons.notes),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nose Images Section
                  Text(
                    'Nose Print Images (10-15 required)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image Upload Button
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(_noseImages.isEmpty 
                        ? 'Upload Nose Images' 
                        : '${_noseImages.length} images selected'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                              borderRadius: BorderRadius.circular(8),
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
                  ElevatedButton(
                    onPressed: _isLoading ? null : _registerCow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}