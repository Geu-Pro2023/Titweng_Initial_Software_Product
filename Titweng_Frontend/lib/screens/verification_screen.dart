import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:titweng/utils/app_theme.dart';
import 'package:titweng/models/cow_model.dart';
import 'package:titweng/services/mock_service.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<File> _uploadedImages = [];
  bool _isScanning = false;
  bool _scanComplete = false;
  CowModel? _foundCow;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImagesFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _uploadedImages = images.map((image) => File(image.path)).toList();
          _scanComplete = false;
          _foundCow = null;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick images: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _uploadedImages.add(File(image.path));
          _scanComplete = false;
          _foundCow = null;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to take photo: $e');
    }
  }

  Future<void> _startVerification() async {
    if (_uploadedImages.isEmpty) {
      _showErrorDialog('Please upload nose print images first');
      return;
    }

    setState(() {
      _isScanning = true;
      _scanComplete = false;
      _foundCow = null;
    });

    _foundCow = await MockService.instance.verifyCow(
      _uploadedImages.map((file) => file.path).toList(),
    );

    setState(() {
      _isScanning = false;
      _scanComplete = true;
    });
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

  void _reportSuspiciousCattle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.suspiciousColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.report_problem,
                color: AppTheme.suspiciousColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Report Cattle'),
          ],
        ),
        content: const Text('This will report the cattle as suspicious to the authorities. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitReport();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.suspiciousColor,
            ),
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _submitReport() {
    showDialog(
      context: context,
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
            const Text('Report Submitted'),
          ],
        ),
        content: const Text('Your report has been submitted to the authorities. Thank you for helping protect the community.'),
        actions: [
          ElevatedButton(
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
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.qr_code_scanner,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cattle Verification',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Verify cattle authenticity',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn().slideX(begin: -0.3, end: 0),

              const SizedBox(height: 40),

              // Upload Buttons
              if (!_scanComplete && !_isScanning) ...[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 120,
                        child: ElevatedButton(
                          onPressed: _takePhoto,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Take Photo',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 120,
                        child: ElevatedButton(
                          onPressed: _pickImagesFromGallery,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_library,
                                size: 40,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upload Images',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate().slideY(begin: 0.3, delay: 200.ms),

                // Image Preview
                if (_uploadedImages.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    '${_uploadedImages.length} images selected',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _uploadedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: FileImage(_uploadedImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 32),

                  // Verify Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _startVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Start Verification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ).animate().slideX(delay: 600.ms),
                ],
              ],

              // Scanning Animation
              if (_isScanning) ...[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 4,
                              ),
                            ),
                          ),
                        ).animate().scale(duration: 1000.ms, curve: Curves.easeInOut),
                        const SizedBox(height: 32),
                        Text(
                          'Scanning...',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(delay: 500.ms),
                        const SizedBox(height: 8),
                        Text(
                          'Analyzing nose print patterns',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ).animate().fadeIn(delay: 700.ms),
                      ],
                    ),
                  ),
                ),
              ],

              // Results Section
              if (_scanComplete) ...[
                Expanded(
                  child: Center(
                    child: _foundCow != null
                        ? _buildRegisteredResult()
                        : _buildNotRegisteredResult(),
                  ).animate().slideY(begin: 0.3, delay: 200.ms),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisteredResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.check_circle,
            size: 50,
            color: AppTheme.successColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Cattle Registered!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This cattle is registered in our system',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cattle Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Name:', _foundCow!.name),
              _buildDetailRow('Age:', '${_foundCow!.age} years'),
              _buildDetailRow('Owner:', _foundCow!.ownerName),
              _buildDetailRow('Location:', '${_foundCow!.location}, ${_foundCow!.state}'),
              _buildDetailRow('Registration ID:', _foundCow!.id),
              _buildDetailRow('Registered:', _foundCow!.registrationDate.toString().split(' ')[0]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotRegisteredResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.error,
            size: 50,
            color: AppTheme.suspiciousColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Not Registered',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This cattle is not found in our system',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.warning,
                color: AppTheme.suspiciousColor,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                'Suspicious Activity?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'If you suspect this cattle might be stolen or involved in illegal activities, please report it to the authorities.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _reportSuspiciousCattle,
            icon: Icon(Icons.report, color: AppTheme.primaryColor),
            label: Text(
              'Report to Authorities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}