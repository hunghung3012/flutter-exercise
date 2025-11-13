import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz; // ✅ Đổi từ latest.dart
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future init() async {
    if (_isInitialized) return;

    // ✅ Khởi tạo timezone đầy đủ
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    // ✅ Xin quyền notification và alarm chính xác
    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _notification.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        print("✅ Thông báo đã được bấm: ${details.payload}");
      },
    );

    _isInitialized = true;
    print("✅ NotificationService đã khởi tạo thành công");
  }

  static Future scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // ✅ Đảm bảo đã khởi tạo
    await init();

    // Chuyển đổi sang timezone local
    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
    final now = tz.TZDateTime.now(tz.local);

    print("🔔 Scheduling notification:");
    print("   ID: $id");
    print("   Hiện tại: $now");
    print("   Thời gian đặt: $tzTime");
    print("   Chênh lệch: ${tzTime.difference(now).inMinutes} phút");

    // ✅ Kiểm tra thời gian có hợp lệ không
    if (tzTime.isBefore(now)) {
      throw Exception("Không thể đặt nhắc nhở trong quá khứ");
    }

    await _notification.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel', // Channel ID
          'Reminders', // Channel name
          channelDescription: 'Kênh thông báo nhắc nhở',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher', // ✅ Thêm icon
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // ✅ Giữ nguyên
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("✅ Đã đặt thông báo ID: $id");
  }

  // ✅ Thêm method hủy notification
  static Future<void> cancelNotification(int id) async {
    await _notification.cancel(id);
    print("🗑️ Đã hủy thông báo ID: $id");
  }

  // ✅ Hủy tất cả notifications
  static Future<void> cancelAllNotifications() async {
    await _notification.cancelAll();
    print("🗑️ Đã hủy tất cả thông báo");
  }

  // ✅ Lấy danh sách pending notifications (debug)
  static Future<void> getPendingNotifications() async {
    final pending = await _notification.pendingNotificationRequests();
    print("📋 Có ${pending.length} thông báo đang chờ:");
    for (var notif in pending) {
      print("   - ID: ${notif.id}, Title: ${notif.title}");
    }
  }

  // Test notification ngay lập tức
  static Future<void> testInstantNotification() async {
    await init();
    final now = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

    await scheduleNotification(
      id: 99999,
      title: "Test Notification",
      body: "Thông báo test sau 5 giây",
      scheduledTime: now,
    );

    print("🧪 Test notification sẽ hiện sau 5 giây");
  }
}