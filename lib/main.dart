import 'package:flutter/material.dart';
import 'package:flutter_ex/projects/p9_reminder_app/services/notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';   // 👈 thêm dòng này
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'projects/p5_note_provider/providers/note_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 👇 Khởi tạo locale cho DateFormat
  await initializeDateFormatting('vi', null);
  await NotificationService.init();

  runApp(const MiniProjectsApp());
}

class MiniProjectsApp extends StatelessWidget {
  const MiniProjectsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: MaterialApp(
        title: "Mini Projects",
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
