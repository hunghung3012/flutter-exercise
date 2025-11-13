import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String skill;

  const SkillChip(this.skill, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.circle, size: 10, color: Colors.green),
      title: Text(skill),
    );
  }
}
