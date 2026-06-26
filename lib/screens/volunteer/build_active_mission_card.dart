import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';

class BuildActiveMissionCardWidget extends StatefulWidget {
  const BuildActiveMissionCardWidget({super.key});

  @override
  State<BuildActiveMissionCardWidget> createState() => _BuildActiveMissionCardWidgetState();
}

class _BuildActiveMissionCardWidgetState extends State<BuildActiveMissionCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xff0D2A3C), Color(0xff2371A2)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, size: 7, color: Colors.orange),
                    SizedBox(width: 5),
                    Text(
                      'Active Mission',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '#FM-2024-047',
                style: TextStyle(color: AppColors.primaryLightest.withOpacity(0.6), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Dal Rice + Sabzi — 40 portions',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 12, color: AppColors.primaryLight),
              const SizedBox(width: 3),
              Text(
                'Hotel Regent, Andheri East',
                style: TextStyle(color: AppColors.primaryLight, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // step tracker
          Row(
            children: [
              _buildStep('Go to\nDonor', true, false),
              _buildStepLine(true),
              _buildStep('Collect\nFood', true, true),
              _buildStepLine(false),
              _buildStep('Go to\nNGO', false, false),
              _buildStepLine(false),
              _buildStep('Deliver', false, false),
            ],
          ),
          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightest,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 0,
              ),
              child: const Text(
                'Continue Mission →',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String label, bool done, bool active) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? (active ? Colors.orange : AppColors.primaryLight) : AppColors.primaryDeep,
            border: Border.all(
              color: active
                  ? Colors.orange
                  : done
                  ? AppColors.primaryLight
                  : AppColors.primaryLight.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Icon(
            done
                ? (active ? Icons.pedal_bike_rounded : Icons.check_rounded)
                : Icons.circle_outlined,
            size: 14,
            color: done ? Colors.white : AppColors.primaryLight.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: done ? Colors.white : AppColors.primaryLight.withOpacity(0.4),
            fontSize: 9,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool done) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(bottom: 20),
        color: done ? AppColors.primaryLight : AppColors.primaryLight.withOpacity(0.2),
      ),
    );
  }
}
