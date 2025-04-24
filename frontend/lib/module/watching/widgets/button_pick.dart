import 'package:flutter/material.dart';

class ButtonPick extends StatefulWidget {
  final String text;
  final int index;
  final int indexSelected;
  final VoidCallback onTap;

  const ButtonPick({
    super.key,
    required this.text,
    required this.index,
    required this.indexSelected,
    required this.onTap,
  });

  @override
  State<ButtonPick> createState() => _ButtonPickState();
}

class _ButtonPickState extends State<ButtonPick> {
  final GlobalKey _textKey = GlobalKey();
  double _textWidth = 0;

  @override
  void initState() {
    super.initState();
    // Delay để đợi render xong rồi đo kích thước
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _textWidth = renderBox.size.width;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: 50,
            child: Center(
              child: Text(
                widget.text,
                key: _textKey,
                style: TextStyle(
                  color: (widget.index == widget.indexSelected)
                      ? Colors.white
                      : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (widget.index == widget.indexSelected)
            Positioned(
              top: 0,
              child: Container(
                width: _textWidth,
                height: 5,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
