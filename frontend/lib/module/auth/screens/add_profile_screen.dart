import 'package:flutter/material.dart';
import 'package:frontend/module/notify/screens/error-notify.dart';
import 'package:frontend/module/notify/screens/success-notify.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/module/auth/screens/profile_selection_screen.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/models/film/category.dart';
import 'package:frontend/providers/category_provider.dart';
import 'package:dio/dio.dart';
class AddProfileScreen extends ConsumerStatefulWidget {
  static const routeName = '/add-profile';

  final int accountId;
  

  const AddProfileScreen({super.key, required this.accountId});

  @override
  ConsumerState<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends ConsumerState<AddProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<Category> _selectedGenres = [];

  String? _selectedAvatar;

  final List<String> ageGroups = ['Dưới 18', '18-25', '26-40', 'Trên 40'];

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

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    try {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      final fetchedGenres = await categoryRepository.getAllCategory();
      setState(() {
        genres = fetchedGenres;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      showErrorNotify(
        context,
        'Error',
        'Failed to fetch categories. Please try again later.',
      );
    }
  }

  List<Category> genres = [];

  void _saveProfile() async {
    final name = _nameController.text;
    final isKid = _isKid ?? false;

    if (name.isEmpty || _selectedAvatar == null) {
            showErrorNotify(
        context,
        'Missing Information',
        'Please fill in all the fields.',
      );
      return;
    }

    if (_selectedGenres.isEmpty) {
      showErrorNotify(
        context,
        'Missing Genres',
        'Please select at least one favorite genre.',
      );
      return;
    }

    try {
      final profileRepository = ref.read(profileRepositoryProvider);
      final newProfile = await profileRepository.addProfile(
        username: name,
        avatar: _selectedAvatar!,
        kid: isKid,
        accountId: widget.accountId,
        favoriteGenres: _selectedGenres,
      );
      print('Profile added: $newProfile');
      final profiles = await ref.refresh(profileProvider(widget.accountId).future);
      print('Fetched profiles: $profiles');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSelectionScreen(
            profiles: profiles,
            accountId: widget.accountId,
          ),
        ),
      );
            showSuccessNotify(context, 
      'Success', 
      'Profile added successfully.');
    } catch (e) {
      _handleAddError(e);
    }
  }
  // Hàm xử lý lỗi đăng nhập
void _handleAddError(dynamic e) {
  //print('Login error: $e');
  String errorMessage = 'An unknown error occurred';

  if (e is DioException) {
    print('DioException: ${e.message}');
    if (e.response != null) {
      print('Response data: ${e.response?.data}');

      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('code')) {
          errorMessage = responseData['code'].toString();
        } else {
          errorMessage = 'An unknown error occurred';
        }
          
      } else if (responseData != null) {
        errorMessage = responseData.toString();
      }
    } else {
      errorMessage = e.message ?? 'An unknown Dio error occurred';
    }
  } 
  if (errorMessage == '1013') {
    errorMessage = 'Maximum number of profiles reached';
  }
  showErrorNotify(
    context,
    'Add Profile Error',
    errorMessage,
  );
}

  bool? _isKid;

  void _toggleGenre(Category genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Profile'),
        titleTextStyle: const TextStyle(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: 'Name',
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
                'Choose Avatar',
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
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: _selectedAvatar == avatar ? Colors.white.withOpacity(0.2) : Colors.transparent,
                          border: Border.all(
                            color: Colors.white,
                            width: _selectedAvatar == avatar ? 5.0 : 0.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              'assets/images/$avatar',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
              const SizedBox(height: 16),
              const Text(
                'Favorite Genres',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: genres.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return GestureDetector(
                    onTap: () => _toggleGenre(genre),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: isSelected ? Colors.red : Colors.white,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        genre.name ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}