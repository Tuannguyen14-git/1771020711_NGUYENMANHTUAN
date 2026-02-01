# 🏸 Pickleball Club Management (PCM) - Fullstack Deployment

**Đồ án Môn học Mobile - Flutter & Backend API**  
**MSSV**: 1771020711  
**Họ tên**: Nguyễn Mạnh Tuấn

---

## 🚀 TRẠNG THÁI TRIỂN KHAI (LIVE)

Dự án đã được triển khai hoàn chỉnh trên môi trường Production để giảng viên có thể test trực tiếp mà không cần cài đặt môi trường backend:

- **🌍 Backend API (Render)**: [https://one771020711-nguyenmanhtuan.onrender.com/](https://one771020711-nguyenmanhtuan.onrender.com/)
- **📚 API Documentation (Swagger)**: [https://one771020711-nguyenmanhtuan.onrender.com/swagger](https://one771020711-nguyenmanhtuan.onrender.com/swagger)
- **📱 Mobile App (Android APK)**: `pcm_mobile/build/app/outputs/flutter-apk/app-release.apk`
- **🌐 Flutter Web (Render - Coming Soon)**: Đang trong quá trình triển khai bản Web.

---

## 📋 Mô tả dự án

Ứng dụng quản lý câu lạc bộ Pickleball **Vợt Thủ Phố Núi**, giải quyết trọn vẹn bài toán từ đặt sân, quản lý hội viên đến thống kê doanh thu thời gian thực:

- ✅ **Quản lý thành viên**: Đăng ký, đăng nhập bảo mật với JWT, tự động tạo hồ sơ hội viên.
- ✅ **Hệ thống đặt sân (Real-time)**: Xem lịch sân trực quan theo ngày, đặt sân theo khung giờ, tự động tính giá.
- ✅ **Ví điện tử (e-Wallet)**: Nạp tiền (Demo), quản lý số dư, thanh toán booking tự động trừ tiền trong ví.
- ✅ **Quản lý giải đấu**: Hiển thị sơ đồ thi đấu (Bracket), đăng ký tham gia giải.
- ✅ **Dashboard Admin**: Biểu đồ doanh thu (Fl Chart), thống kê Top Members chi tiêu, quản lý toàn bộ hệ thống.

---

## 🛠️ Công nghệ sử dụng (Production Stack)

### **Frontend (Mobile & Web)**
- **Flutter 3.x**: Đa nền tảng (Android & Web).
- **State Management**: Provider (Quản lý trạng thái ứng dụng tập trung).
- **Network**: Dio (Xử lý request API hiệu quả).
- **UI/UX**: Custom theme (vibrant colors), fl_chart (biểu đồ), table_calendar.

### **Backend (API)**
- **ASP.NET Core 8.0**: Framework backend mạnh mẽ nhất hiện nay.
- **Entity Framework Core**: Quản lý database theo mô hình Code First.
- **Database**: **PostgreSQL** (Triển khai trên Cloud Render).
- **Authentication**: JWT (JSON Web Token) bảo mật cao.
- **Deployment**: Dockerized (Container cho phép chạy ổn định trên mọi môi trường).

---

## 📦 Cấu trúc thư mục

```
MOBILE_FLUTTER_1771020711_NguyenManhTuan/
├── pcm_mobile/              # Flutter Mobile App (Source Code)
│   ├── build/outputs/apk/   # Chứa file APK đã build hoàn chỉnh
│   └── lib/                 # Logic xử lý Dart
├── Pcm.Api/                 # .NET Backend API (Source Code)
│   ├── Pcm.Api/             # Logic API Controllers & Models
│   ├── Dockerfile           # Cấu hình đóng gói Docker
│   └── render.yaml          # Cấu hình Infrastructure-as-code cho Render
└── README.md
```

---

## 👤 Tài khoản Test (Khuyên dùng)

Hệ thống đã được Seed sẵn dữ liệu mẫu để giảng viên dễ dàng kiểm tra các tính năng nâng cao:

### **1. Tài khoản Quản trị (Admin)**
- **Username**: `admin`
- **Password**: `123`
- **Đặc quyền**: Xem Dashboard thống kê doanh thu, quản lý giải đấu.

### **2. Tài khoản Hội viên (Member)**
- **Username**: Có thể tự đăng ký mới trực tiếp trên App.
- **Tài khoản mẫu**: `user` / `123` (Nếu đã đăng ký).

---

## 🏁 Hướng dẫn test nhanh (Cho Giảng Viên)

1. **Test trên Android**:
   - Tải file `app-release.apk` trong thư mục `pcm_mobile/build/app/outputs/flutter-apk/`.
   - Cài đặt lên điện thoại/giả lập.
   - Đăng nhập bằng tài khoản `admin` / `123`.

2. **Test API trực tiếp**:
   - Truy cập [Swagger UI](https://one771020711-nguyenmanhtuan.onrender.com/swagger).
   - Thử gọi các endpoint `/api/auth/login` hoặc `/api/members`.

3. **Lưu ý về Cold Start**:
   - Vì dùng gói **Render Free Tier**, nếu server không có request trong 15 phút sẽ tự "ngủ".
   - **Lần đầu mở App có thể mất 30-60 giây** để server thức dậy (Timeout). Bạn chỉ cần đợi 1 phút và nhấn lại là sẽ cực kỳ nhanh.

---

## 📝 Thành tựu kỹ thuật đã đạt được

- ✅ **Full Deployment**: Triển khai thành công cả App và API lên môi trường Cloud.
- ✅ **Database Migration**: Chuyển đổi thành công từ SQL Server sang PostgreSQL để chạy trên môi trường Web/Cloud.
- ✅ **Security**: Triển khai cơ chế phân quyền Admin/Member chặt chẽ qua Token.
- ✅ **Auto-Migration**: Hệ thống tự động khởi tạo database và dữ liệu mẫu khi deploy.

---

**Dự án được thực hiện với mục tiêu mang lại trải nghiệm chuyên nghiệp nhất cho người dùng!**

**© 2024 Nguyễn Mạnh Tuấn - Pickleball Vợt Thủ Phố Núi**
