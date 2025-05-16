import 'package:flutter/material.dart';

class WarningNotifyScreen extends StatefulWidget {
  final String title;
  final String message;

  const WarningNotifyScreen({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  _WarningNotifyScreenState createState() => _WarningNotifyScreenState();
}

class _WarningNotifyScreenState extends State<WarningNotifyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _showPopup();
  }

  void _showPopup() async {
    setState(() {
      _visible = true;
    });
    _controller.forward();
  }

  void _hidePopup(bool result) async {
    await _controller.reverse();
    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54.withOpacity(0.7),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.yellowAccent, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Notify
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 255, 230, 0).withOpacity(0.1),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.warning_amber_outlined,
                          color: Color.fromARGB(255, 255, 183, 0),
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 151, 136, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Message
                    Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    // Yes No Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => _hidePopup(true),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 8.0),
                          ),
                          child: const Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () => _hidePopup(false),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 8.0),
                          ),
                          child: const Text("No"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to show the Warning notify screen
Future<bool?> showWarningNotify(
    BuildContext context, String title, String message) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    builder: (context) => WarningNotifyScreen(
      title: title,
      message: message,
    ),
  );
}
