import 'package:flutter/material.dart';
import 'package:frontend/module/home/screens/home_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/module/auth/screens/profile_selection_screen.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/providers/auth_provider.dart';


class AddProfileScreen extends ConsumerStatefulWidget { // Chuyển thành ConsumerStatefulWidget
  static const routeName = '/add-profile';

  final int accountId; // Thêm accountId làm tham số

  const AddProfileScreen({super.key, required this.accountId});

  @override
  ConsumerState<AddProfileScreen> createState() => _AddProfileScreenState(); // Sử dụng ConsumerState
}

class _AddProfileScreenState extends ConsumerState<AddProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedAgeGroup;
  final List<String> _selectedInterests = [];

  String? _selectedAvatar;

  final List<String> ageGroups = ['Dưới 18', '18-25', '26-40', 'Trên 40'];
  final List<String> interests = [
    'Phim Hành Động',
    'Phim Hài',
    'Phim Kinh Dị',
    'Phim Tình Cảm',
  ];

  final List<String> avatarOptions = [
    'avatar-1.png',
    'avatar-2.png',
    'avatar-3.png',
    'avatar-4.png',
    'avatar-5.png',
    'avatar-6.png',
    'avatar-7.png',
    'avatar-8.png',
    'avatar-9.png',
    'avatar-10.png',
  ];

  void _saveProfile() async {
    final name = _nameController.text;
    final isKid = _isKid ?? false; // Lấy giá trị của radio button

    if (name.isEmpty || _selectedAvatar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin và chọn avatar')),
      );
      return;
    }

    try {
      final profileRepository = ref.read(profileRepositoryProvider);
      final newProfile = await profileRepository.addProfile(
        username: name,
        avatar: _selectedAvatar!, // Lưu tên file avatar
        kid: isKid,
        accountId: widget.accountId,
      );
      print('Profile added: $newProfile');
      // Gọi lại hàm fetch profiles
      final profiles = await ref.refresh(profileProvider(widget.accountId).future); // Làm mới provider và lấy danh sách profile mới nhất
      print('Fetched profiles: $profiles'); // Log sau khi lấy danh sách profile
      // Navigate to ProfileSelectionScreen with profiles và accountId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSelectionScreen(
            profiles: profiles,
            accountId: widget.accountId, // Truyền accountId
          ),
        ),
      );
    } catch (e) {
      print('Error adding profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể thêm profile')),
      );
    }
  }

  bool? _isKid; // Thêm biến để lưu trạng thái radio button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Actor Mới'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  hintText: 'Tên',
                  controller: _nameController,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  hintColor: Colors.grey,
                  borderRadius: 8.0,
                  borderColor: Colors.white,
                  borderWidth: 1.5,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chọn Avatar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: avatarOptions.length,
                    itemBuilder: (context, index) {
                      final avatar = avatarOptions[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAvatar = avatar;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedAvatar == avatar ? Colors.red : Colors.transparent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Image.asset(
                            'assets/images/$avatar',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedAgeGroup,
                  items: ageGroups
                      .map(
                        (ageGroup) => DropdownMenuItem(
                          value: ageGroup,
                          child: Text(
                            ageGroup,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAgeGroup = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Độ tuổi',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  dropdownColor: Colors.black,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kid',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                        value: true,
                        groupValue: _isKid,
                        onChanged: (value) {
                          setState(() {
                            _isKid = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                        value: false,
                        groupValue: _isKid,
                        onChanged: (value) {
                          setState(() {
                            _isKid = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: CustomButton(
                    text: 'Lưu',
                    onPressed: _saveProfile,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    borderRadius: 8.0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
