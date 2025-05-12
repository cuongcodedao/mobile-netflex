import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/module/notify/screens/error-notify.dart';
import 'package:frontend/module/notify/screens/success-notify.dart';
import 'package:frontend/module/notify/screens/warning-notify.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/storage_service.dart';

class ManagerAccountScreen extends ConsumerStatefulWidget {
  const ManagerAccountScreen({super.key});

  @override
  ConsumerState<ManagerAccountScreen> createState() =>
      _ManagerAccountScreenState();
}

class _ManagerAccountScreenState extends ConsumerState<ManagerAccountScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEditing = false;
  String? _email;
  String? _currentPlan;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final authRepository = ref.read(authRepositoryProvider);
    final userId = await StorageService().getUserInfo();
    if (userId != null) {
      print('User ID: $userId');
      try {
        final user = await authRepository.getUserInfo(userId);
        setState(() {
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
          _email = user.email;
          _currentPlan = user.currentPlan.planName;
        });
      } catch (e) {
        print('Error fetching user info: $e');
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Quản lý tài khoản',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Email', _email ?? "Loading..."),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Họ và tên',
                    '${_firstNameController.text} ${_lastNameController.text}',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Gói hiện tại', _currentPlan ?? "Loading..."),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isEditing = !_isEditing),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        _isEditing ? 'HỦY CẬP NHẬT' : 'CẬP NHẬT THÔNG TIN',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_isEditing) ...[
              const SizedBox(height: 24),
              Text(
                'Thông tin cập nhật',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildEditField('Họ', _firstNameController),
              const SizedBox(height: 16),
              _buildEditField('Tên', _lastNameController),
              const SizedBox(height: 16),
              _buildEditField(
                'Mật khẩu',
                _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 24),
            ],

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isEditing ? _updateUserInfo : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'LƯU THAY ĐỔI',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _deleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'XÓA TÀI KHOẢN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Future<void> _updateUserInfo() async {
    bool? check = await showWarningNotify(
    context,
    'Cảnh báo',
    'Bạn có muốn luu thay đổi không?',
    );
    if (check == false) {
      return;
      } else {
      final authRepository = ref.read(authRepositoryProvider);
      final userId = await StorageService().getUserInfo();
      if (userId == null) {
        showErrorNotify(context, "Lỗi", "Không tìm thấy thông tin người dùng");
        return;
      }

      try {
        final response = await authRepository.updateUserInfo(
          id: userId,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          password: _passwordController.text,
        );
        //print('Update response: $response');
          if (response['code'] == 1000) {
            // Assuming 1000 is your success code
            showSuccessNotify(
              context,
              "Thành công",
              "Cập nhật thông tin thành công",
            );
            await _fetchUserInfo(); // Refresh user info
            setState(() => _isEditing = false);
          } else {
            showErrorNotify(
              context,
              "Lỗi",
              response['message'] ?? "Cập nhật thông tin thất bại",
            );
          }
        
      } catch (e) {
        print('Error updating user info: $e');
        showErrorNotify(context, "Lỗi", "Cập nhật thông tin thất bại");
      }
    }
  }
    Future<void> _deleteAccount() async {
      showErrorNotify(context, "Lỗi", "Chức năng này chỉ dành cho admin");
        return;
      final authRepository = ref.read(authRepositoryProvider);
      final userId = await StorageService().getUserInfo();
      if (userId == null) {
        showErrorNotify(context, "Lỗi", "Không tìm thấy thông tin người dùng");
        return;
      }

        bool? check = await showWarningNotify(
            context,
            'Cảnh báo',
            'Bạn có muốn xóa tài khoản không?',
        );
        if (check == false) {
          return;
        } else {
          try {
            final response = await authRepository.deleteAccount(userId);
            if (response['code'] == 1000) {
              // Assuming 1000 is your success code
              showSuccessNotify(
                context,
                "Thành công",
                "Xóa tài khoản thành công",
              );
              StorageService().clearStorage(); // Xóa thông tin người dùng
              // Chuyển hướng về trang đăng nhập hoặc trang chính
                Navigator.popUntil(context, (route) => route.isFirst);
            } else {
                showErrorNotify(
                    context,
                    "Lỗi",
                    response['message'] ?? "Xóa tài khoản thất bại",
                );
                }
            } catch (e) {
            print('Error deleting account: $e');
            showErrorNotify(context, "Lỗi", "Xóa tài khoản thất bại");
            }
        }
    }
}
