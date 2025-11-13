📱 Mini Flutter Projects – Full Collection
📝 Giới thiệu

Repo chứa 10 mini project Flutter, mỗi project tập trung một kỹ năng quan trọng: UI, State, API, SQLite, Notification, Camera và Firebase Authentication.

📚 Mục lục

Giới thiệu

Cấu trúc dự án

Danh sách 10 mini projects

Yêu cầu cài đặt

Chạy dự án

Ảnh demo

🗂 Cấu trúc dự án
lib/
├── main.dart
├── app_router.dart
└── projects/
├── p1_profile_card/
├── p2_todo_provider/
├── p3_news_api/
├── p4_chat_ui/
├── p5_note_provider/
├── p6_weather_api/
├── p7_expense_tracker/
├── p8_photo_gallery/
├── p9_reminder_app/
└── p10_firebase_auth/

🧱 Danh sách 10 mini projects
1️⃣ Profile Card App – UI Layout

Column, Row, Avatar

Thiết kế danh thiếp đẹp

📷 Ảnh demo:
images/p1.png

2️⃣ To-Do App – Provider State

Provider + ChangeNotifier

Quản lý danh sách công việc

📷 images/p2.png

3️⃣ News App – REST API

http

JSON parsing

FutureBuilder

📷 images/p3.png

4️⃣ Chat UI – Messenger Style

Bubble UI

ListView reverse

Hỗ trợ gửi tin nhắn

📷 images/p4.png

5️⃣ Notes App – Provider + CRUD

Provider

Lưu trữ ghi chú realtime

📷 images/p5.png

6️⃣ Weather App – API + Geolocator

OpenWeather API

Lấy vị trí GPS

UI gradient hiện đại

📷 images/p6.png

7️⃣ Expense Tracker – SQLite + fl_chart

SQLite

Biểu đồ PieChart

Quản lý chi tiêu theo tháng

📷 images/p7.png

8️⃣ Photo Gallery App – Camera

image_picker

permission_handler

GridView gallery

(Optional) Lưu ảnh local

📷 images/p8.png

9️⃣ Reminder App – Local Notifications

flutter_local_notifications

DateTimePicker

Lên lịch nhắc nhở

📷 images/p9.png

🔟 Firebase Login App – Firebase Auth

firebase_core

firebase_auth

StreamBuilder lắng nghe trạng thái user

📷 images/p10.png

🛠 Yêu cầu cài đặt
Flutter SDK ≥ 3.0

https://flutter.dev/docs/get-started/install

Các package sử dụng
provider
http
geolocator
sqflite
path
fl_chart
image_picker
permission_handler
flutter_local_notifications
firebase_core
firebase_auth

Firebase CLI (cho Project 10)
dart pub global activate flutterfire_cli

▶️ Chạy dự án
1. Clone source
   git clone https://github.com/yourname/flutter-mini-projects.git
   cd flutter-mini-projects

2. Cài dependency
   flutter pub get

3. Chạy ứng dụng
   flutter run

🖼 Ảnh demo
Project	Image
Profile App	images/p1.png
Todo Provider	images/p2.png
News API	images/p3.png
Chat UI	images/p4.png
Notes	images/p5.png
Weather	images/p6.png
Expense Tracker	images/p7.png
Photo Gallery	images/p8.png
Reminder App	images/p9.png
Firebase Login	images/p10.png
🎉 Kết luận

Bộ này giúp luyện đầy đủ kiến thức từ cơ bản → nâng cao:
UI, State, API, Database, Camera, Notifications, Firebase Auth.
Có thể dùng làm template cho app thật.