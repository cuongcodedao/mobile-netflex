import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Unlimited entertainment, one low price',
      'description': 'All of Netflix, starting at just \$6.99.',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'title': 'Download and watch offline',
      'description': 'Always have something to watch offline.',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'title': 'No annoying contracts',
      'description': 'Join today, cancel anytime.',
      'image': 'assets/images/onboarding3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  FittedBox(
                    alignment: Alignment.topCenter,
                    fit: BoxFit.contain,
                    child: Image.asset(_onboardingData[index]['image']!,),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(1),
                        ],
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _onboardingData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _onboardingData[index]['description']!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              verticalDirection: VerticalDirection.up,
              children: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "GET STARTED",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPage == index
                                ? Color(0xFFE50914)
                                : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
