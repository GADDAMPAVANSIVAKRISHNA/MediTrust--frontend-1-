import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// A card that exhibits glassmorphism in Dark Mode and a crisp, softly shadowed card in Light Mode
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? color;
  final Border? border;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 20.0,
    this.blur = 15.0,
    this.color,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget cardBody = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? (isDark 
          ? Colors.white.withOpacity(0.06) 
          : AppColors.cardLight),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(
          color: isDark 
            ? Colors.white.withOpacity(0.08) 
            : AppColors.borderLight,
          width: 1.0,
        ),
        boxShadow: isDark ? null : AppColors.softShadows,
      ),
      child: child,
    );

    if (onTap != null) {
      cardBody = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardBody,
      );
    }

    if (margin != null) {
      cardBody = Padding(
        padding: margin!,
        child: cardBody,
      );
    }

    if (isDark) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: cardBody,
        ),
      );
    }

    return cardBody;
  }
}

/// A premium button component that supports Gradients, Filled Solid, and Outline states
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGradient;
  final bool isOutline;
  final Color? color;
  final Color? textColor;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isGradient = true,
    this.isOutline = false,
    this.color,
    this.textColor,
    this.height = 54.0,
    this.borderRadius = 16.0,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? AppColors.primaryTeal;
    final textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textColor ?? (isOutline ? AppColors.primaryTeal : Colors.white),
    );

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutline ? AppColors.primaryTeal : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(text, style: textStyle),
      ],
    );

    if (isOutline) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: themeColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Center(child: content),
        ),
      );
    }

    if (isGradient && !isLoading) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryTeal.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Center(child: content),
        ),
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isLoading ? themeColor.withOpacity(0.6) : themeColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isLoading ? null : [
          BoxShadow(
            color: themeColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Center(child: content),
      ),
    );
  }
}

/// Customizable modern Input Field matching design forms
class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontSize: 14,
            ),
            prefixIcon: prefixIcon != null 
              ? Icon(prefixIcon, color: AppColors.primaryTeal, size: 20) 
              : null,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// A simple rating star indicator widget
class RatingStars extends StatelessWidget {
  final double rating;
  final int reviewsCount;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.reviewsCount = 0,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: AppColors.warning, size: size),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        if (reviewsCount > 0) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewsCount reviews)',
            style: const TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 12,
            ),
          ),
        ]
      ],
    );
  }
}

/// Standardized headers on sub-screens
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 18,
          ),
        ),
        if (actionText != null && onActionPressed != null)
          TextButton(
            onPressed: onActionPressed,
            child: Text(
              actionText!,
              style: const TextStyle(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
