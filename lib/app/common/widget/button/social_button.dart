import 'package:flutter/material.dart';
import '../../constant/app_colors.dart';

class SocialButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;
  final double size;
  final bool isLoading;

  const SocialButton({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.size = 48,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(size),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primaryPurple,
                ),
              )
            : Image.asset(
                imagePath,
                height: 28,
              ),
      ),
    );
  }
}