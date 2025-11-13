import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/skill_chip.dart';
import '../widgets/social_button.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  bool isDark = false;

  final Color primaryColor = const Color.fromARGB(255, 83, 177, 117);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryColor,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text(
            "Personal Profile",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Switch(
              value: isDark,
              activeColor: Colors.white,
              onChanged: (v) => setState(() => isDark = v),
            )
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ProfileHeader(primaryColor: primaryColor),
              const SizedBox(height: 24),

              // ABOUT
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const ListTile(
                  leading: Icon(Icons.person),
                  title: Text("About Me", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    "Hi! I'm a Flutter developer learning UI, State Management, API, "
                        "and Firebase. I enjoy building modern mobile apps.",
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // SKILLS
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.star),
                      title: Text("Skills", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SkillChip("Flutter / Dart"),
                    SkillChip("REST APIs"),
                    SkillChip("Firebase & Firestore"),
                    SkillChip("UI/UX Design"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // SOCIAL LINKS
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.link),
                      title: Text("Social Links", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SocialButton(icon: Icons.facebook, label: "Facebook"),
                    SocialButton(icon: Icons.code, label: "GitHub"),
                    SocialButton(icon: Icons.work, label: "LinkedIn"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
