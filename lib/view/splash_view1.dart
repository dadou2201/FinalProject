import 'package:app_sport/utils/global_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: GlobalColors.mainColor,
      body: Center(
        child: Image.asset(
         "assets/SPORTNARE.png"

        ),
      ),
    );
  }


}
