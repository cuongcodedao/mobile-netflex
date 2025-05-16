import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/profile/profile_model.dart';
import 'package:frontend/module/home/screens/home_page.dart';
import 'package:frontend/module/home/screens/search_page.dart';
import 'package:frontend/module/home/widgets/horizontal_film_list.dart';
import 'package:frontend/module/home/widgets/feature_banner.dart';
import 'package:frontend/module/profile/screens/profile_screen.dart';
import 'package:frontend/module/profile/widgets/button_avata.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:frontend/providers/film_provider.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final ProfileModel profile;

  const HomeScreen({super.key, required this.profile});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get _widgetOptions => [
    HomePage(profile: widget.profile),
    const Text(
      '🔍 Search',
      style: TextStyle(fontSize: 24, color: Colors.white),
    ),
    const SearchPage(),
    const Text(
      'Setting Page',
      style: TextStyle(fontSize: 24, color: Colors.white),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Home Screen", style: TextStyle(color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              child: FutureBuilder<String>(
                future: _getProfileAvatar(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Icon(Icons.person);
                  }

                  final avatarUrl = snapshot.data!;
                  return CircleAvatar(
                    backgroundImage: AssetImage('assets/images/$avatarUrl'),
                    radius: 20,
                    backgroundColor: Colors.transparent,
                  );
                },
            ),
          ),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // <- QUAN TRỌNG
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pause), label: 'Hot & New'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<String> _getProfileAvatar() async {
    final profileID = await StorageService().getProfileId();
    if (profileID == null) {
      print ('nan');
      return '';
    }

    // Sử dụng read để lấy giá trị Future của provider
    final profileAsyncValue = await ref.read(
      profileDetailProvider(profileID).future,
    );
    print ('Fetched profile: $profileAsyncValue');
    print ('Fetched profile avatar: ${profileAsyncValue.avatar}');

    return profileAsyncValue.avatar;
  }
}
