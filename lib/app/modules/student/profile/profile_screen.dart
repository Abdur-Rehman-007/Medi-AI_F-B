import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_theme.dart';
import '../../../../app/services/auth_service.dart';
import '../../../../app/services/doctor_service.dart';

export 'profile_binding.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Doctor fields
  final _specializationController = TextEditingController();
  final _roomController = TextEditingController();
  final _bioController = TextEditingController();
  bool isAvailable = false;
  bool isDoctor = false;

  bool isEditMode = false;
  bool showPasswordSection = false;

  // Settings state
  bool pushNotifications = true;
  bool medicineReminders = true;

  final authService = Get.find<AuthService>();
  DoctorService? doctorService;

  @override
  void initState() {
    super.initState();
    final user = authService.currentUser.value;
    _nameController.text = user?.name ?? '';
    _phoneController.text = user?.phone ?? '';

    isDoctor = user?.role.toLowerCase() == 'doctor';
    if (isDoctor) {
      if (Get.isRegistered<DoctorService>()) {
        doctorService = Get.find<DoctorService>();
        _loadDoctorProfile();
      }
    }
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pushNotifications = prefs.getBool('pushNotifications') ?? true;
      medicineReminders = prefs.getBool('medicineReminders') ?? true;
    });
  }

  Future<void> _loadDoctorProfile() async {
    if (doctorService == null) return;
    try {
      final response = await doctorService!.getMyProfile();
      if (response.success && response.data != null) {
        final data = response.data!;
        // Handle User object if present
        if (data.containsKey('user')) {
          final user = data['user'];
          if (user != null) {
            _nameController.text = user['fullName'] ?? '';
            _phoneController.text = user['phoneNumber'] ?? '';
          }
        }
        setState(() {
          _specializationController.text = data['specialization'] ?? '';
          _roomController.text = data['roomNumber'] ?? '';
          _bioController.text = data['bio'] ?? '';
          isAvailable = data['isAvailable'] == true;
        });
      }
    } catch (e) {
      print('Error loading doctor profile: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _specializationController.dispose();
    _roomController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (isDoctor && doctorService != null) {
        // Save doctor profile
        final data = {
          'FullName': _nameController.text,
          'PhoneNumber': _phoneController.text,
          'Specialization': _specializationController.text,
          'RoomNumber': _roomController.text,
          'Bio': _bioController.text,
          'IsAvailable': isAvailable,
        };

        final response = await doctorService!.updateProfile(data);
        if (response.success) {
          _showSuccess('Profile updated successfully');
          // Update local auth state if name changed
          if (authService.currentUser.value != null) {
            final updatedUser = authService.currentUser.value!;
            updatedUser.name = _nameController.text;
            updatedUser.phone = _phoneController.text;
            authService.currentUser.refresh();
          }
        } else {
          _showError(response.message);
        }
      } else {
        // TODO: Implement student profile update
        _showSuccess('Profile updated (Local Only)');
      }
      setState(() => isEditMode = false);
    } catch (e) {
      _showError('Failed to update profile: $e');
    }
  }

  void _showSuccess(String msg) {
    Get.snackbar(
      'Success',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _showError(String msg) {
    Get.snackbar(
      'Error',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _changePassword() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      'Success',
      'Password changed successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    setState(() => showPasswordSection = false);
  }

  void _logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authService.logout();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser.value;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (!isEditMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => isEditMode = true),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Picture
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.primary,
                  child: isDoctor
                      ? const Icon(Icons.medical_information,
                          size: 48, color: Colors.white)
                      : Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'U',
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
                        ),
                ),
                if (isEditMode)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: AppTheme.primary,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt,
                            size: 20, color: Colors.white),
                        onPressed: () {
                          Get.snackbar(
                            'Change Photo',
                            'Select photo from gallery or camera',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppTheme.primary,
                            colorText: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Personal Information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      enabled: isEditMode,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: user?.email ?? '',
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      enabled: isEditMode,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: user?.cmsId ?? '',
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'CMS ID',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: user?.department ?? '',
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.school),
                      ),
                    ),
                    if (isDoctor) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      const Text(
                        'Doctor Details',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _specializationController,
                        decoration: const InputDecoration(
                          labelText: 'Specialization',
                          prefixIcon: Icon(Icons.medical_services_outlined),
                          border: OutlineInputBorder(),
                        ),
                        enabled: isEditMode,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _roomController,
                        decoration: const InputDecoration(
                          labelText: 'Room Number',
                          prefixIcon: Icon(Icons.meeting_room_outlined),
                          border: OutlineInputBorder(),
                        ),
                        enabled: isEditMode,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bioController,
                        decoration: const InputDecoration(
                          labelText: 'Bio',
                          prefixIcon: Icon(Icons.description_outlined),
                          border: OutlineInputBorder(),
                        ),
                        enabled: isEditMode,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Available for Appointments'),
                        value: isAvailable,
                        onChanged: isEditMode
                            ? (val) => setState(() => isAvailable = val)
                            : null,
                        secondary: const Icon(Icons.check_circle_outline),
                      ),
                    ],
                    if (isEditMode) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() => isEditMode = false);
                              _nameController.text = user?.name ?? '';
                              _phoneController.text = user?.phone ?? '';
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Save Changes'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Security
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Security',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(
                              () => showPasswordSection = !showPasswordSection);
                        },
                        icon: Icon(
                          showPasswordSection
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                        label: const Text('Change Password'),
                      ),
                    ],
                  ),
                  if (showPasswordSection) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _currentPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Current Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _newPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm New Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Update Password'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // App Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive appointment reminders'),
                    value: pushNotifications,
                    onChanged: (value) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('pushNotifications', value);
                      setState(() => pushNotifications = value);
                      Get.snackbar(
                        'Settings Updated',
                        'Push notifications ${value ? 'enabled' : 'disabled'}',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    activeColor: AppTheme.primary,
                  ),
                  SwitchListTile(
                    title: const Text('Medicine Reminders'),
                    subtitle: const Text('Get notified for medicine intake'),
                    value: medicineReminders,
                    onChanged: (value) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('medicineReminders', value);
                      setState(() => medicineReminders = value);
                      Get.snackbar(
                        'Settings Updated',
                        'Medicine reminders ${value ? 'enabled' : 'disabled'}',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    activeColor: AppTheme.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          ElevatedButton.icon(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.logout),
            label: const Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
