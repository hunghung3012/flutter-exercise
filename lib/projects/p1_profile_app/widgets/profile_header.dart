import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Color primaryColor;

  const ProfileHeader({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.9),
            primaryColor.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Column(
        children: const [
          CircleAvatar(
            radius: 55,
            backgroundImage: NetworkImage(
              "https://i.imgur.com/BoN9kdC.png",
            ),
          ),
          SizedBox(height: 14),

          Text(
            "Your Name",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 4),

          Text(
            "Flutter Developer",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
