import 'package:flutter/material.dart';
import 'package:seva_meal/screens/shared_widgets/upsidedown_clipper.dart';

class WaveClipBanner extends StatelessWidget {
  final double? height;
  final bool? isLogoRequired;
  const WaveClipBanner({super.key, this.height, this.isLogoRequired});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        width: double.infinity,
        height: height ?? MediaQuery.of(context).size.height * 0.33,
        color: const Color.fromARGB(255, 218, 237, 255),
        child: isLogoRequired ?? false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/app_logo.png', height: 130),
                  SizedBox(height: 12),
                  Text(
                    'Food that carries kindness',
                    style: TextStyle(
                      color: Color(0xff0D2A3C),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              )
            : SizedBox(),
      ),
    );
  }
}
