import 'package:flutter/material.dart';
import 'package:frontend/module/home/screens/home_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class AddProfileScreen extends StatefulWidget {
  static const routeName = '/add-profile';

  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedAgeGroup;
  final List<String> _selectedInterests = [];

  final List<String> ageGroups = ['Dưới 18', '18-25', '26-40', 'Trên 40'];
  final List<String> interests = [
    'Phim Hành Động',
    'Phim Hài',
    'Phim Kinh Dị',
    'Phim Tình Cảm',
  ];

  void _saveProfile() {
    final name = _nameController.text;
    // if (name.isEmpty || _selectedAgeGroup == null || _selectedInterests.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
    //   );
    //   return;
    // }

    print(
      'New Profile: $name, Age Group: $_selectedAgeGroup, Interests: $_selectedInterests',
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Actor Mới'),
        titleTextStyle: TextStyle(
          color: Colors.white, // Set title color to white
          fontSize: 20, // Increased font size
          fontWeight: FontWeight.bold, // Bold title
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black, // Set background to black
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Ensure proper height
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  hintText: 'Tên',
                  controller: _nameController,
                  backgroundColor:
                      Colors.black, // Black background for text field
                  textColor: Colors.white,
                  hintColor: Colors.grey,
                  borderRadius: 8.0,
                  borderColor: Colors.white, // White border
                  borderWidth: 1.5,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedAgeGroup,
                  items:
                      ageGroups
                          .map(
                            (ageGroup) => DropdownMenuItem(
                              value: ageGroup,
                              child: Text(
                                ageGroup,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ), // Increased font size
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
                    ), // Increased font size
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ), // White border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ), // White border
                    ),
                  ),
                  dropdownColor: Colors.black, // Dropdown background color
                ),
                const SizedBox(height: 16),
                Text(
                  'Sở thích',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ), // Increased font size
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children:
                      interests.map((interest) {
                        final isSelected = _selectedInterests.contains(
                          interest,
                        );
                        return FilterChip(
                          label: Text(
                            interest,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          selected: isSelected,
                          backgroundColor: Colors.black,
                          selectedColor: Colors.white,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedInterests.add(interest);
                              } else {
                                _selectedInterests.remove(interest);
                              }
                            });
                          },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
