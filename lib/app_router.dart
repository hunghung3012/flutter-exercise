import 'package:flutter/material.dart';
import 'package:flutter_ex/projects/p3_news_reader/pages/news_home.dart';
import 'package:flutter_ex/projects/p4_chat_ui/pages/chat_home.dart';
import 'package:flutter_ex/projects/p5_note_provider/pages/notes_home.dart';
import 'package:flutter_ex/projects/p5_note_provider/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'projects/p1_profile_app/pages/profile_home.dart';
import 'package:flutter_ex/projects/p2_todo_app/pages/todo_home.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeMenuScreen());

      case '/p1':
        return MaterialPageRoute(builder: (_) => const ProfileHomePage());

      case '/p2':
        return MaterialPageRoute(builder: (_) => const TodoHomePage());

      case '/p3':
        return MaterialPageRoute(builder: (_) => const NewsHomePage());

      case '/p4':
        return MaterialPageRoute(builder: (_) => const ChatHomePage());

      case '/p5':
        return MaterialPageRoute(
          builder: (context) => Consumer<NoteProvider>(
            builder: (context, noteProvider, _) => const NotesHomePage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route không tồn tại")),
          ),
        );
    }
  }
}

class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      "1. Profile App",
      "2. Todo App",
      "3. News Reader",
      "4. Chat UI",
      "5. Notes (Provider)",
      "6. Weather App",
      "7. Expense Tracker",
      "8. Photo Gallery",
      "9. Reminder App",
      "10. Firebase Login",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Mini Projects")),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final route = "/p${index + 1}";

          return ListTile(
            title: Text(projects[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, route),
          );
        },
      ),
    );
  }
}