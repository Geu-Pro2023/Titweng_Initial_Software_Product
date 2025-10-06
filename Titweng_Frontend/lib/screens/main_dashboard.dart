import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:titweng/utils/app_theme.dart';
import 'package:titweng/models/user_model.dart';
import 'package:titweng/services/mock_service.dart';
import 'package:titweng/models/cow_model.dart';
import 'package:titweng/screens/admin_register_screen.dart';
import 'package:titweng/screens/verification_screen.dart';
import 'package:titweng/screens/report_screen.dart';
import 'package:titweng/screens/profile_screen.dart';

class MainDashboard extends StatefulWidget {
  final UserModel user;
  
  const MainDashboard({super.key, required this.user});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  List<CowModel> _registeredCows = [];
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final cows = await MockService.instance.getAllCows();
      setState(() {
        _registeredCows = cows;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<Widget> get _screens {
    if (widget.user.isAdmin) {
      return [
        _buildAdminDashboard(),
        _buildRegisterScreen(),
        _buildVerificationScreen(),
        _buildReportsScreen(),
        _buildProfileScreen(),
      ];
    } else {
      return [
        _buildUserDashboard(),
        _buildVerificationScreen(),
        _buildReportScreen(),
        _buildProfileScreen(),
      ];
    }
  }

  List<BottomNavigationBarItem> get _navItems {
    if (widget.user.isAdmin) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          activeIcon: Icon(Icons.add_circle),
          label: 'Register',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner_outlined),
          activeIcon: Icon(Icons.qr_code_scanner),
          label: 'Verify',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.report_outlined),
          activeIcon: Icon(Icons.report),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner_outlined),
          activeIcon: Icon(Icons.qr_code_scanner),
          label: 'Verify',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.report_problem_outlined),
          activeIcon: Icon(Icons.report_problem),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.navBarColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppTheme.navBarColor,
            selectedItemColor: AppTheme.navSelectedColor,
            unselectedItemColor: AppTheme.navUnselectedColor,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            elevation: 0,
            items: _navItems,
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDashboard() {
    return Container(
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
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Authority Dashboard',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Manage cattle registrations',
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
            ),

            // Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Registered',
                      '${_registeredCows.length}',
                      Icons.pets,
                      AppTheme.successColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Reports',
                      '${_reports.length}',
                      Icons.report_problem,
                      AppTheme.warningColor,
                    ),
                  ),
                ],
              ).animate().slideY(begin: 0.3, delay: 200.ms),
            ),

            const SizedBox(height: 24),

            // Recent Activity
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Registrations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : _registeredCows.isEmpty
                              ? _buildEmptyState('No cattle registered yet', Icons.pets_outlined)
                              : ListView.builder(
                                  itemCount: _registeredCows.length,
                                  itemBuilder: (context, index) {
                                    final cow = _registeredCows[index];
                                    return _buildCowCard(cow, index);
                                  },
                                ),
                    ),
                  ],
                ),
              ).animate().slideY(begin: 0.3, delay: 400.ms),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDashboard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.userGradient,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.dashboard_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Cattle verification & security',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user_rounded, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('USER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Quick Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Verifications',
                      '12',
                      Icons.verified_rounded,
                      AppTheme.successColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Reports Made',
                      '3',
                      Icons.report_rounded,
                      AppTheme.warningColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Actions
              Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            'Verify Cattle',
                            'Scan nose print',
                            Icons.qr_code_scanner_rounded,
                            AppTheme.primaryGradient,
                            () => setState(() => _currentIndex = 1),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildActionCard(
                            'Report Issue',
                            'Report suspicious activity',
                            Icons.report_problem_rounded,
                            AppTheme.warningGradient,
                            () => setState(() => _currentIndex = 2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recent Activity
              Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text('View All', style: TextStyle(color: AppTheme.primaryColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildActivityItem(
                      'Cattle Verified',
                      'Successfully verified cattle #C001',
                      Icons.check_circle_rounded,
                      AppTheme.successColor,
                      '2 hours ago',
                    ),
                    _buildActivityItem(
                      'Report Submitted',
                      'Suspicious activity reported',
                      Icons.report_rounded,
                      AppTheme.warningColor,
                      '1 day ago',
                    ),
                    _buildActivityItem(
                      'Profile Updated',
                      'Contact information updated',
                      Icons.person_rounded,
                      AppTheme.infoColor,
                      '3 days ago',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Security Tips
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.infoColor.withOpacity(0.1), AppTheme.accentColor.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.infoColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppTheme.infoColor, AppTheme.accentColor]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.security_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Security Tip',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Always verify cattle authenticity before purchase. Report any suspicious activities immediately.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.lightTextColor,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, List<Color> gradient, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon, Color color, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.lightTextColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.lightTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCowCard(CowModel cow, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppTheme.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.pets,
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
                  cow.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Owner: ${cow.ownerName}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.lightTextColor,
                  ),
                ),
                Text(
                  '${cow.location}, ${cow.state}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.lightTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Registered',
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.successColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: (index * 100).ms).slideX(begin: 0.3, end: 0).fadeIn();
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppTheme.lightTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.lightTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterScreen() => const AdminRegisterScreen();
  Widget _buildVerificationScreen() => const VerificationScreen();
  
  Widget _buildReportsScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.adminGradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.report,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reports Center',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Manage suspicious activity reports',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(),
              
              const SizedBox(height: 40),
              
              // Reports List
              Expanded(
                child: Container(
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
                  child: _reports.isEmpty
                      ? _buildEmptyState('No reports yet', Icons.report_outlined)
                      : ListView.builder(
                          itemCount: _reports.length,
                          itemBuilder: (context, index) {
                            final report = _reports[index];
                            return _buildReportCard(report, index);
                          },
                        ),
                ),
              ).animate().slideY(begin: 0.3, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildReportScreen() => ReportScreen(user: widget.user);
  
  Widget _buildProfileScreen() => ProfileScreen(user: widget.user);
  
  Widget _buildReportCard(Map<String, dynamic> report, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.warningColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.report_problem,
              color: AppTheme.warningColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report['type'] ?? 'Suspicious Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report['location'] ?? 'Unknown Location',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.lightTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Pending',
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.warningColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: (index * 100).ms).slideX(begin: 0.3, end: 0).fadeIn();
  }
}