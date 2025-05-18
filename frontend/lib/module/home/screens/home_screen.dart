import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

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
      style: TextStyle(
        fontSize: 24,
        fontFamily: "Montserrat",
        color: Colors.white,
      ),
    ),
    const SearchPage(),
    const Text(
      'Setting Page',
      style: TextStyle(
        fontSize: 24,
        fontFamily: "Montserrat",
        color: Colors.white,
      ),
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
        leading: Image.asset("assets/images/Netflix.jpg"),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => ProfileScreen(), transition: Transition.rightToLeft);
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              child: FutureBuilder<String>(
                future: _getProfileAvatar(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SpinKitSpinningLines(
                      color: Colors.redAccent,
                      size: 20.0,
                    );
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.manage_accounts);
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Icon(Icons.person);
                  }

                  final avatarUrl = snapshot.data!;
                  return Container(
                    width: 40, // chiều rộng của hình vuông
                    height: 40, // chiều cao của hình vuông
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/$avatarUrl'),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.rectangle, // Hình vuông
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(right: 5, top: 5),
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
    StorageService storageService = StorageService();
    int? accountId = await storageService.getUserInfo();
    int? profileId = await storageService.getProfileId();
    String? accessToken = await storageService.getAccessToken();
    if (accountId == null || profileId == null || accessToken == null) {
      print('Account ID không tồn tại');
      return '';
    }
    ProfileModel profile = await ProfileRepository(
      ApiService(),
    ).fetchProfile2(accountId, accessToken, profileId);
    return profile.avatar;
  }
}
