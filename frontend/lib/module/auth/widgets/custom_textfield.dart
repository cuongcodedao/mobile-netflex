import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Color backgroundColor;
  final Color textColor;
  final Color hintColor;
  final double borderRadius;
  final EdgeInsets contentPadding;
  final Color borderColor;
  final double borderWidth;
  final TextInputType? keyboardType; // Thêm keyboardType

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.backgroundColor = const Color(0xFF5C5C5C),
    this.textColor = Colors.white,
    this.hintColor = Colors.white,
    this.borderRadius = 8.0,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.keyboardType, // Thêm vào constructor
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Trạng thái để theo dõi việc ẩn/hiện mật khẩu
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Khởi tạo trạng thái ẩn/hiện dựa trên prop isPassword
    _obscureText = widget.isPassword;
  }

  // Hàm để chuyển đổi trạng thái ẩn/hiện
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      // Sử dụng trạng thái _obscureText thay vì widget.isPassword trực tiếp
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType, // Sử dụng keyboardType
      style: TextStyle(color: widget.textColor, fontSize: 16),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintColor,
          fontSize: 16,
        ),
        filled: true,
        fillColor: widget.backgroundColor,
        contentPadding: widget.contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor, // Giữ màu viền khi focus, hoặc thay đổi nếu muốn
            width: widget.borderWidth,
          ),
        ),
        // --- THÊM SUFFIX ICON Ở ĐÂY ---
        suffixIcon: widget.isPassword // Chỉ hiển thị icon nếu là ô password
            ? IconButton(
                icon: Icon(
                  // Chọn icon dựa trên trạng thái _obscureText
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  // Đặt màu cho icon (ví dụ: giống màu hint hoặc màu viền)
                  color: widget.hintColor.withOpacity(0.7),
                ),
                onPressed: _togglePasswordVisibility, // Gọi hàm khi nhấn nút
              )
            : null, // Không hiển thị icon nếu không phải ô password
      ),
    );
  }
}