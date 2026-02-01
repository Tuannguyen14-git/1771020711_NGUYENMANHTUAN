# 🏸 Pickleball Club Management (PCM) - Mobile App

**Đồ án Môn học Mobile - Flutter**  
**MSSV**: 1771020711  
**Họ tên**: Nguyễn Mạnh Tuấn

---

## 📋 Mô tả dự án

Ứng dụng quản lý câu lạc bộ Pickleball **Vợt Thủ Phố Núi**, bao gồm:
- ✅ **Quản lý thành viên** (Đăng ký, đăng nhập, phân quyền)
- ✅ **Đặt sân** (Lịch đặt sân, xác nhận booking)
- ✅ **Ví điện tử** (Nạp tiền, thanh toán)
- ✅ **Giải đấu** (Xem danh sách, đăng ký tham gia)
- ✅ **Thống kê & Tài chính** (Dashboard Admin, doanh thu, top members)

---

## 🛠️ Công nghệ sử dụng

### **Frontend (Mobile)**
- **Flutter** 3.10+
- **Dart** SDK 3.10+
- **State Management**: Provider
- **HTTP Client**: Dio
- **UI Libraries**: fl_chart, table_calendar

### **Backend (API)**
- **.NET 8.0** (ASP.NET Core Web API)
- **Entity Framework Core** (SQL Server)
- **JWT Authentication**
- **SignalR** (Real-time notifications)

---

## 📦 Cấu trúc thư mục

```
MOBILE_FLUTTER_1771020711_NguyenManhTuan/
├── pcm_mobile/              # Flutter Mobile App
│   ├── lib/
│   │   ├── models/          # Data models
│   │   ├── services/        # API services
│   │   ├── providers/       # State management
│   │   ├── ui/screens/      # UI screens
│   │   └── main.dart
│   └── pubspec.yaml
│
├── Pcm.Api/                 # .NET Backend API
│   ├── Pcm.Api/
│   │   ├── Controllers/     # API Controllers
│   │   ├── Models/          # Database models
│   │   ├── DTOs/            # Data Transfer Objects
│   │   └── Program.cs
│   └── Pcm.Api.sln
│
└── README.md
```

---

## 🚀 Hướng dẫn cài đặt và chạy

### **1. Yêu cầu hệ thống**
- **Flutter SDK** 3.10+ ([Tải tại đây](https://flutter.dev))
- **.NET SDK** 8.0+ ([Tải tại đây](https://dotnet.microsoft.com))
- **SQL Server** (hoặc LocalDB)
- **Visual Studio 2022** hoặc **VS Code**

### **2. Chạy Backend API**

```bash
# Di chuyển vào thư mục Backend
cd Pcm.Api/Pcm.Api

# Restore packages
dotnet restore

# Chạy ứng dụng
dotnet run
```

**Backend sẽ chạy tại**: `https://localhost:7043`  
**Swagger UI**: `https://localhost:7043/swagger/index.html`

### **3. Chạy Mobile App**

```bash
# Di chuyển vào thư mục Mobile
cd pcm_mobile

# Cài đặt dependencies
flutter pub get

# Chạy ứng dụng (Chrome Web)
flutter run -d chrome

# Hoặc Android Emulator
flutter run -d emulator-5554
```

**Lưu ý**: Đảm bảo file `lib/core/constants.dart` có `baseUrl` trỏ đúng địa chỉ Backend:
```dart
static const String baseUrl = 'https://localhost:7043';
```

---

## 👤 Tài khoản Test

### **Tài khoản Admin**
- **Username**: `admin`
- **Password**: `123`
- **Quyền**: Xem Dashboard thống kê, quản lý toàn bộ hệ thống

### **Tài khoản Member**
- **Username**: `user`
- **Password**: `123`
- **Quyền**: Đặt sân, xem giải đấu, quản lý ví

> ⚠️ **Lưu ý**: Anh cũng có thể **tạo tài khoản mới** bằng nút "ĐĂNG KÝ TÀI KHOẢN MỚI" trên màn hình Login.

---

## 🎯 Các chức năng chính

### **1. Đăng nhập & Đăng ký**
- Đăng nhập bằng Username/Password
- Đăng ký tài khoản mới (tự động tạo Member)
- JWT Authentication

### **2. Dashboard (Trang chủ)**
- Hiển thị thông tin thành viên (Tên, Tier, DUPR Rating)
- Số dư ví điện tử
- **Admin Dashboard** (chỉ Admin): Xem thống kê tổng quan

### **3. Đặt sân (Booking)**
- Xem lịch sân theo tuần/tháng
- Đặt sân theo khung giờ
- Xác nhận đặt sân

### **4. Ví điện tử (Wallet)**
- Xem số dư và lịch sử giao dịch
- Nạp tiền vào ví (Demo)
- Thanh toán booking bằng ví

### **5. Giải đấu (Tournament)**
- Xem danh sách giải đấu (Sắp diễn ra, Đang đấu, Kết thúc)
- Xem chi tiết giải đấu với **Bracket visualization**
- Đăng ký tham gia giải đấu

### **6. Thống kê (Admin Dashboard)**
- **Tổng doanh thu** (từ booking)
- **Số lượng booking**
- **Số lượng thành viên**
- **Biểu đồ doanh thu** theo tháng
- **Top 5 thành viên** chi tiêu nhiều nhất

### **7. Hồ sơ (Profile)**
- Xem thông tin cá nhân
- Đăng xuất

---

## 🌐 API Endpoints (Backend)

### **Authentication**
- `POST /api/auth/register` - Đăng ký tài khoản mới
- `POST /api/auth/login` - Đăng nhập (trả về JWT token)
- `GET /api/auth/me` - Lấy thông tin user hiện tại

### **Bookings**
- `GET /api/bookings` - Lấy danh sách booking
- `POST /api/bookings` - Tạo booking mới
- `POST /api/bookings/confirm` - Xác nhận booking

### **Wallet**
- `GET /api/wallet/transactions/{memberId}` - Xem lịch sử giao dịch
- `POST /api/wallet/deposit` - Nạp tiền vào ví

### **Statistics (Admin only)**
- `GET /api/statistics/dashboard` - Thống kê tổng quan
- `GET /api/statistics/revenue?year=2024` - Doanh thu theo tháng
- `GET /api/statistics/top-members` - Top 5 members

---

## 📹 Video Demo

> **Lưu ý**: Anh cần quay video demo (5-10 phút) thao tác các chức năng chính:
> 1. Đăng nhập
> 2. Xem Dashboard (User & Admin)
> 3. Đặt sân
> 4. Xem ví và lịch sử giao dịch
> 5. Xem giải đấu
> 6. (Admin) Xem thống kê

**Upload lên YouTube (Unlisted)** hoặc **Google Drive** (Public View).

---

## 📤 Hướng dẫn nộp bài

### **1. Link Repository (GitHub/GitLab)**
```bash
# Tạo repo mới trên GitHub
git init
git add .
git commit -m "Initial commit - PCM Mobile App"
git remote add origin https://github.com/<your-username>/pcm-mobile.git
git push -u origin main
```

### **2. Link Sản phẩm Online**
- **Backend Swagger**: `https://localhost:7043/swagger/index.html` (nếu deploy lên Azure/Heroku thì cung cấp link online)
- **Mobile App**: Nếu deploy lên web hosting, cung cấp link. Nếu APK, cung cấp link Google Drive.

### **3. Link Video Demo**
- Quay video demo và upload lên YouTube (Unlisted)
- Hoặc upload lên Google Drive (mở quyền View)

### **4. Tài khoản Test**
```
👤 Admin: admin / 123
👤 Member: user / 123
```

---

## 📝 Ghi chú kỹ thuật

### **Các vấn đề đã giải quyết**
- ✅ JWT Authentication với .NET Backend
- ✅ CORS Configuration cho Flutter Web/Mobile
- ✅ State Management với Provider
- ✅ API Integration với Dio
- ✅ Real-time updates (SignalR - optional)
- ✅ Responsive UI cho Mobile & Web

### **Database Setup**
- Backend tự động tạo database khi chạy lần đầu (Code First Migration)
- Connection string: `appsettings.json`

---

## 📞 Liên hệ

- **Email**: nguyenmanhtuan@example.com
- **MSSV**: 1771020711
- **Lớp**: Mobile Development

---

## 📜 License

Dự án này được phát triển cho mục đích học tập.

**© 2024 Nguyễn Mạnh Tuấn - Vợt Thủ Phố Núi**
