import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final bool obscureText;
  final VoidCallback? onSuffixTap;

  const CustomTextField({
    super.key,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconColor,
    this.obscureText = false,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey.shade500, size: 20)
            : null,
        suffixIcon: suffixIcon != null
            ? InkWell(
                onTap: onSuffixTap,
                focusNode: FocusNode(skipTraversal: true),
                child: Icon(
                  suffixIcon, 
                  color: suffixIconColor ?? Colors.grey.shade500, 
                  size: 20
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBlue),
        ),
      ),
    );
  }
}
