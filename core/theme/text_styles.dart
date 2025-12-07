import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  static final TextStyle heading = GoogleFonts.notoSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.elderlyText,
  );

  static final TextStyle tileLabel = GoogleFonts.notoSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.elderlyText,
  );

  static final TextStyle subtitle = GoogleFonts.notoSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.elderlyText,
  );
}
