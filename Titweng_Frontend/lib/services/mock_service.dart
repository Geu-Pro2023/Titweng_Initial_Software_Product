import 'package:titweng/models/cow_model.dart';
import 'package:titweng/models/user_model.dart';

class MockService {
  static MockService? _instance;
  static MockService get instance => _instance ??= MockService._();
  MockService._();

  // Mock data storage
  static List<CowModel> _cows = [];

  // Mock authentication
  Future<UserModel?> authenticateUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    if (email == 'admin@titweng.com' && password == 'admin123') {
      return UserModel(
        id: 'admin_1',
        name: 'Admin User',
        email: email,
        phone: '+211123456789',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );
    } else if (email.contains('@') && password.length >= 6) {
      return UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Regular User',
        email: email,
        phone: '+211987654321',
        role: UserRole.user,
        createdAt: DateTime.now(),
      );
    }
    return null;
  }

  // Mock user creation
  Future<UserModel?> createUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    // Mock validation - check if email already exists
    if (email == 'admin@titweng.com') {
      return null; // Email already exists
    }
    
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: fullName,
      email: email,
      phone: phone,
      role: UserRole.user,
      createdAt: DateTime.now(),
    );
  }

  // Mock cow registration
  Future<void> registerCow(CowModel cow) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate processing
    _cows.add(cow);
  }

  // Mock get all cows
  Future<List<CowModel>> getAllCows() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_cows.reversed);
  }

  // Mock cow verification
  Future<CowModel?> verifyCow(List<String> imagePaths) async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate ML processing
    
    // Mock verification - randomly return a cow or null
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    
    if (random == 0 && _cows.isNotEmpty) {
      return _cows.first; // Return first registered cow
    } else if (random == 1) {
      // Return a mock registered cow
      return CowModel(
        id: 'COW_MOCK_123',
        name: 'Bella',
        age: 4,
        ownerName: 'John Doe',
        ownerEmail: 'john.doe@example.com',
        location: 'Juba',
        state: 'Central Equatoria',
        witness: 'Jane Smith',
        noseImagePaths: [],
        registrationDate: DateTime.now().subtract(const Duration(days: 30)),
        additionalDetails: 'Healthy cattle, vaccinated',
      );
    }
    
    return null; // Not registered
  }

  // Mock report submission
  Future<String> submitReport(Map<String, dynamic> reportData) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'RPT${DateTime.now().millisecondsSinceEpoch}';
  }

  // Mock user settings
  static Map<String, dynamic> _userSettings = {
    'fontSize': 'medium', // small, medium, large
    'notifications': true,
    'darkMode': false,
  };

  Map<String, dynamic> getUserSettings() {
    return Map.from(_userSettings);
  }

  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _userSettings.addAll(settings);
  }

  Future<bool> deleteUserAccount(String userId) async {
    await Future.delayed(const Duration(seconds: 2));
    // Mock account deletion
    return true;
  }
}