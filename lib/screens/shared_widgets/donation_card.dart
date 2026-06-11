import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';

class DonationCard extends StatelessWidget {
  const DonationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 80,
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.blue,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/card_image.jpg', fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sabji's + rice", style: TextStyle(height: 1)),
                    Text(
                      '12th Dec 2022 - Aasra shelter',
                      style: TextStyle(fontSize: 12, color: AppColors.grayDark, height: 1),
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color.fromARGB(255, 218, 243, 255),
                          ),
                          child: Text(
                            "Delivered",
                            style: TextStyle(color: AppColors.primary, fontSize: 12),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color.fromARGB(255, 222, 255, 217),
                          ),
                          child: Text(
                            "40 portions",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 17, 60, 13),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryLightest),
                child: InkWell(
                  onTap: () {},
                  child: Icon(Icons.chevron_right, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
