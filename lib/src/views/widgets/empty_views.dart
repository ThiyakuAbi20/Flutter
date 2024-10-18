import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/res/assets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class EmptyViews extends StatelessWidget {
  const EmptyViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(AnimationAssets.empty),
        Text("Things look empty here. Tap + to start",style: GoogleFonts.poppins(fontSize: 18)),
      ],
    );
  }
}