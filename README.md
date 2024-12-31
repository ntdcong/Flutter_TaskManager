# Ứng dụng Task Manager Flutter 👜

Ứng dụng quản lý công việc đơn giản được xây dựng bằng Flutter. Tích hợp xác thực Firebase và lưu trữ dữ liệu thời gian thực.

## Tính năng 📜

- Xác thực Firebase cho đăng nhập/đăng xuất
- Tạo, chỉnh sửa và xóa công việc
- Quản lý trạng thái công việc (Chưa bắt đầu, Đang thực hiện, Hoàn thành)
- Lọc công việc theo trạng thái
- Đồng bộ dữ liệu thời gian thực với Firestore

## Cài đặt 🔧

### Yêu cầu hệ thống 

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Firebase](https://firebase.google.com/docs/flutter/setup)

### Thiết lập

1. Sao chép kho lưu trữ:
```bash
git clone https://github.com/ntdcong/Flutter_TaskManager.git
```

2. Cài đặt các gói phụ thuộc:
```bash
flutter pub get
```

### Cấu hình Firebase

1. Tạo/chọn dự án trong [Firebase Console](https://console.firebase.google.com/)
2. Làm theo [Hướng dẫn cài đặt Firebase Flutter](https://firebase.flutter.dev/docs/overview)
3. Tải file cấu hình:
   - Android: `android/app/google-services.json`

### Chạy ứng dụng

```bash
flutter run
```

## Cấu trúc dự án ⚙

- **lib/**
  - `main.dart`: Điểm khởi đầu
  - `screens/`: Các màn hình ứng dụng
  - `models/`: Các lớp dữ liệu
  - `widgets/`: Widget tái sử dụng
- **assets/**: Tài nguyên tĩnh
- **android/**: Cấu hình nền tảng

## Tích hợp Firebase 🔥

- **Authentication**: Đăng nhập/đăng xuất người dùng
- **Firestore**: Lưu trữ và đồng bộ công việc thời gian thực

## Hướng dẫn sử dụng 🤓

### Đăng nhập
Nhập thông tin đăng nhập để truy cập màn hình quản lý công việc

### Quản lý công việc
- Thêm: Nhập công việc và nhấn biểu tượng " + "
- Sửa: Chọn công việc và nhấn biểu tượng bút chì " ✏ "
- Xóa: Chọn công việc và nhấn biểu tượng thùng rác " 🗑 "
- Thay đổi trạng thái: Chuyển đổi giữa Chưa bắt đầu, Đang thực hiện hoặc Hoàn thành " ⋮ "

### Đăng xuất
Nhấn biểu tượng đăng xuất trên thanh công cụ

## Công nghệ 💻

- Flutter
- Firebase Authentication
- Cloud Firestore

## Tính năng tương lai ❓

- Nhắc nhở công việc
- Cải thiện giao diện người dùng
- Chức năng tìm kiếm
- ...
