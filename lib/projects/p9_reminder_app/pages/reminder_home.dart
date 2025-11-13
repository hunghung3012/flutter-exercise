import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class ReminderHomePage extends StatefulWidget {
  const ReminderHomePage({super.key});

  @override
  State<ReminderHomePage> createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  final Color primary = const Color(0xFF53B175);

  final TextEditingController titleController = TextEditingController();
  DateTime? selectedTime;

  List<Map<String, dynamic>> reminders = [];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  // ✅ Khởi tạo notification service
  Future<void> _initializeNotifications() async {
    await NotificationService.init();
    // ✅ Debug: Kiểm tra pending notifications
    await NotificationService.getPendingNotifications();
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          selectedTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _scheduleReminder() async {
    if (titleController.text.isEmpty || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập tiêu đề và chọn thời gian")),
      );
      return;
    }

    // ✅ Kiểm tra thời gian có hợp lệ không
    if (selectedTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Không thể đặt nhắc nhở trong quá khứ"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      print("🕐 Thời gian hiện tại: ${DateTime.now()}");
      print("⏰ Thời gian đặt nhắc nhở: $selectedTime");
      print("⏳ Chênh lệch: ${selectedTime!.difference(DateTime.now()).inMinutes} phút");

      await NotificationService.scheduleNotification(
        id: id,
        title: "Nhắc nhở",
        body: titleController.text,
        scheduledTime: selectedTime!,
      );

      setState(() {
        reminders.insert(0, {
          'id': id,
          'title': titleController.text,
          'time': selectedTime!,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đã đặt nhắc nhở lúc ${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}"),
          backgroundColor: Colors.green,
        ),
      );

      titleController.clear();
      setState(() => selectedTime = null);

      // ✅ Debug: Kiểm tra lại pending notifications
      await NotificationService.getPendingNotifications();
    } catch (e) {
      print("❌ Lỗi: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ Xóa reminder và hủy notification
  Future<void> _deleteReminder(int index) async {
    final reminderId = reminders[index]['id'];

    // Hủy notification
    await NotificationService.cancelNotification(reminderId);

    setState(() {
      reminders.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã xóa nhắc nhở"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final reminderDate = DateTime(dt.year, dt.month, dt.day);

    String dateStr;
    if (reminderDate == today) {
      dateStr = "Hôm nay";
    } else if (reminderDate == tomorrow) {
      dateStr = "Ngày mai";
    } else {
      dateStr = "${dt.day}/${dt.month}/${dt.year}";
    }

    return "$dateStr lúc ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ứng dụng Nhắc Nhở"),
        elevation: 0,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          // ✅ Nút test notification
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () async {
              await NotificationService.testInstantNotification();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Test notification sau 5 giây")),
              );
            },
            tooltip: "Test Notification",
          ),
        ],
      ),
      body: Column(
        children: [
          // Form đặt nhắc nhở
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Tiêu đề nhắc nhở",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.edit_note, color: primary),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: _pickTime,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selectedTime == null
                                ? "Chọn thời gian"
                                : _formatDateTime(selectedTime!),
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedTime == null ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _scheduleReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.alarm_add),
                      SizedBox(width: 8),
                      Text("Đặt Nhắc Nhở", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Danh sách nhắc nhở
          Expanded(
            child: reminders.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "Chưa có nhắc nhở nào",
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                final isPast = reminder['time'].isBefore(DateTime.now());

                return Dismissible(
                  key: Key(reminder['id'].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteReminder(index),
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 28),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isPast ? Colors.grey[200] : primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.notifications_active,
                          color: isPast ? Colors.grey : primary,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        reminder['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isPast ? Colors.grey : Colors.black87,
                          decoration: isPast ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: isPast ? Colors.grey : primary),
                            const SizedBox(width: 4),
                            Text(
                              _formatDateTime(reminder['time']),
                              style: TextStyle(
                                fontSize: 13,
                                color: isPast ? Colors.grey : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red[300],
                        onPressed: () => _deleteReminder(index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}