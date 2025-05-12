import 'package:flutter/material.dart';

class ErrorNotifyScreen extends StatefulWidget {
  final String title;
  final String message;

  const ErrorNotifyScreen({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  _ErrorNotifyScreenState createState() => _ErrorNotifyScreenState();
}

class _ErrorNotifyScreenState extends State<ErrorNotifyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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

  void _hidePopup() async {
    await _controller.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hidePopup,
      child: Material(
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.redAccent, width: 2.0),
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
                          color: Colors.redAccent.withOpacity(0.1),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      // Title
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Message
                      Text(
                        widget.message,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12.0),
                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show the error notify screen
void showErrorNotify(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    builder: (context) => ErrorNotifyScreen(
      title: title,
      message: message,
    ),
  );
}
