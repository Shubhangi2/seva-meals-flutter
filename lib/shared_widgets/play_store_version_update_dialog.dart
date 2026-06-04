import 'package:seva_meal/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayStoreVersionUpdateDialog extends StatelessWidget {
  final String packageName;
  const PlayStoreVersionUpdateDialog({super.key, required this.packageName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Container(
            color: Colors.red,
            height: 50,
            child: const Center(
              child: Text(
                "Update Application",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.white,
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Please update Application from google play store",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "कृपया गूगल प्ले स्टोर से एप्लीकेशन अपडेट करें",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.oldBorderColor),
                      onPressed: () async {
                        String url = "market://details?id=$packageName";
                        String url2 = "https://play.google.com/store/apps/details?id=$packageName";
                        if (!await launchUrl(Uri.parse(url))) {
                          if (!await launchUrl(Uri.parse(url2))) {
                            throw Exception('Could not launch $url2');
                          }
                        }
                      },
                      child: const Text("Update", style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
