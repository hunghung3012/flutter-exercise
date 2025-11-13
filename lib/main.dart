// import 'package:flutter/material.dart';
// import 'package:flutter_ex/projects/p9_reminder_app/services/notification_service.dart';
// import 'package:intl/date_symbol_data_local.dart';   // 👈 thêm dòng này
// import 'package:provider/provider.dart';
// import 'app_router.dart';
// import 'projects/p5_note_provider/providers/note_provider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // 👇 Khởi tạo locale cho DateFormat
//   await initializeDateFormatting('vi', null);
//   await NotificationService.init();
//   await Firebase.initializeApp();
//   runApp(const MiniProjectsApp());
// }
//
// class MiniProjectsApp extends StatelessWidget {
//   const MiniProjectsApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => NoteProvider()),
//       ],
//       child: MaterialApp(
//         title: "Mini Projects",
//         debugShowCheckedModeBanner: false,
//         onGenerateRoute: AppRouter.generateRoute,
//         initialRoute: '/',
//         theme: ThemeData(
//           useMaterial3: true,
//           brightness: Brightness.light,
//         ),
//         darkTheme: ThemeData(
//           useMaterial3: true,
//           brightness: Brightness.dark,
//         ),
//         themeMode: ThemeMode.system,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';   // file auto-generate bởi FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print("🔥 Firebase connected successfully!");
  } catch (e) {
    print("❌ Firebase initialization FAILED: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase Test App",
      debugShowCheckedModeBanner: false,
      home: const FirebaseTestScreen(),
    );
  }
}

class FirebaseTestScreen extends StatelessWidget {
  const FirebaseTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Connection Test"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Text(
            "Nếu không có lỗi ở console thì Firebase đã kết nối thành công!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
