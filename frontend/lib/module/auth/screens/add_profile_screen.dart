import 'package:flutter/material.dart';
import 'package:frontend/module/notify/screens/error-notify.dart';
import 'package:frontend/module/notify/screens/success-notify.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';
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

  // Define the set of genre names NOT suitable for kids
  // Using a Set for efficient `contains` lookups
  final Set<String> _nonKidFriendlyGenreNames = {
    'Hành Động', 'Miền Tây', 'Cổ Trang', 'Chiến Tranh',
    'Kinh Dị', 'Phim 18+', 'Tình Cảm', 'Hình Sự',
    // Add any other genres that are not kid-friendly by their exact name from the API
  };

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    try {
      if (mounted) {
        final categoryRepository = ref.read(categoryRepositoryProvider);
        final fetchedGenres = await categoryRepository.getAllCategory();
        if (mounted) {
          setState(() {
            genres = fetchedGenres;
          });
        }
      }
    } catch (e) {
      print('Error fetching categories: $e');
      if (mounted) {
        showErrorNotify(
          context,
          'Error',
          'Failed to fetch categories. Please try again later.',
        );
      }
    }
  }

  List<Category> genres = [];

  void _saveProfile() async {
    final name = _nameController.text;
    final isKid = _isKid;

    if (name.isEmpty) {
      showErrorNotify(
        context,
        'Missing Information',
        'Please enter a name for the profile.',
      );
      return;
    }
    if (_selectedAvatar == null) {
      showErrorNotify(
        context,
        'Missing Information',
        'Please choose an avatar.',
      );
      return;
    }
    if (_isKid == null) {
      showErrorNotify(
        context,
        'Missing Information',
        'Please specify if this profile is for a kid.',
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

    // Additional check: if it's a kid profile, ensure no non-kid-friendly genres are accidentally selected
    // This is a safeguard, as the UI should prevent this, but good to have.
    if (_isKid == true) {
      final hasNonKidGenre = _selectedGenres.any(
        (g) => _nonKidFriendlyGenreNames.contains(g.name),
      );
      if (hasNonKidGenre) {
        showErrorNotify(
          context,
          'Invalid Selection',
          'Kid profiles cannot have certain genres selected. Please adjust selection.',
        );
        // Optionally, auto-remove them here before proceeding, or just rely on the UI logic.
        // _selectedGenres.removeWhere((g) => _nonKidFriendlyGenreNames.contains(g.name));
        // setState(() {}); // if you modify _selectedGenres
        return;
      }
    }

    try {
      final profileRepository = ref.read(profileRepositoryProvider);
      final String? accessToken = await StorageService().getAccessToken();
      if (accessToken == null) {
        showErrorNotify(context, 'Error', 'Access token not found.');
        return;
      }
      final newProfile = await profileRepository.addProfile2(
        username: name,
        avatar: _selectedAvatar!,
        kid: isKid!,
        accountId: widget.accountId,
        favoriteGenres: _selectedGenres,
        acccesToken: accessToken,
      );
      print('Profile added: $newProfile');

      await Future.delayed(const Duration(milliseconds: 300));
      final profiles = await ProfileRepository(
        ApiService(),
      ).fetchProfiles2(widget.accountId, accessToken);
      print('Fetched profiles after add: $profiles');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProfileSelectionScreen(
                profiles: profiles,
                accountId: widget.accountId,
              ),
        ),
        (Route<dynamic> route) => false,
      );
      showSuccessNotify(context, 'Success', 'Profile added successfully.');
    } catch (e) {
      if (mounted) {
        _handleAddError(e);
      }
    }
  }

  void _handleAddError(dynamic e) {
    String errorMessage = 'An unknown error occurred';
    if (e is DioException) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('message')) {
            errorMessage = responseData['message'].toString();
          } else if (responseData.containsKey('code')) {
            errorMessage = responseData['code'].toString();
          } else {
            errorMessage =
                'An unknown error occurred with the server response.';
          }
        } else if (responseData != null) {
          errorMessage = responseData.toString();
        }
      } else {
        errorMessage = e.message ?? 'An unknown Dio error occurred';
      }
    } else {
      print('Non-Dio Error: $e');
    }
    if (errorMessage == '1013' ||
        errorMessage.toLowerCase().contains("profile limit exceeded")) {
      errorMessage = 'Maximum number of profiles reached for this account.';
    }
    showErrorNotify(context, 'Add Profile Error', errorMessage);
  }

  bool? _isKid;

  void _toggleGenre(Category genre) {
    // Prevent selecting non-kid-friendly genres if _isKid is true
    if (_isKid == true && _nonKidFriendlyGenreNames.contains(genre.name)) {
      // Optionally show a message, or just do nothing
      print("Cannot select '${genre.name}' for a kid profile.");
      return;
    }

    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  void _setIsKid(bool? value) {
    setState(() {
      _isKid = value;
      // If setting to 'kid = true', remove any selected non-kid-friendly genres
      if (_isKid == true) {
        _selectedGenres.removeWhere(
          (genre) => _nonKidFriendlyGenreNames.contains(genre.name),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter genres to display based on _isKid status
    List<Category> displayableGenres = List.from(
      genres,
    ); // Create a mutable copy
    if (_isKid == true) {
      displayableGenres.retainWhere(
        (genre) => !_nonKidFriendlyGenreNames.contains(genre.name),
      );
    }

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
                borderColor: Colors.white70,
                borderWidth: 1.0,
              ),
              const SizedBox(height: 24),
              const Text(
                'Choose Avatar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: avatarOptions.length,
                  itemBuilder: (context, index) {
                    final avatar = avatarOptions[index];
                    final isAvatarSelected = _selectedAvatar == avatar;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = avatar;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 100,
                        height: 90,
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        decoration: BoxDecoration(
                          color:
                              isAvatarSelected
                                  ? Colors.red.withOpacity(0.3)
                                  : Colors.grey[800],
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color:
                                isAvatarSelected
                                    ? Colors.redAccent
                                    : Colors.white38,
                            width: isAvatarSelected ? 5.0 : 0,
                          ),
                          boxShadow:
                              isAvatarSelected
                                  ? [
                                    BoxShadow(
                                      color: Colors.redAccent.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                  : [],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/images/$avatar',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Is this profile for a kid?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
                      onChanged: _setIsKid, // Use the new method
                      activeColor: Colors.red,
                      contentPadding: EdgeInsets.zero,
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
                      onChanged: _setIsKid, // Use the new method
                      activeColor: Colors.red,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Favorite Genres',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              if (genres.isEmpty)
                const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                )
              else if (_isKid == true && displayableGenres.isEmpty)
                Padding(
                  // Show a message if kid profile and no kid-friendly genres
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      "No suitable genres available for a kid's profile.",
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children:
                      displayableGenres.map((genre) {
                        // Use displayableGenres
                        final isSelected = _selectedGenres.contains(genre);
                        return GestureDetector(
                          onTap: () => _toggleGenre(genre),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.red : Colors.grey[800],
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.redAccent
                                        : Colors.white38,
                                width: 1.5,
                              ),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.4),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                      : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  genre.name ?? 'Unknown',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 8.0),
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              const SizedBox(height: 32),
              Center(
                child: CustomButton(
                  text: 'Save Profile',
                  onPressed: _saveProfile,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  borderRadius: 8.0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 50,
                  ),
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
