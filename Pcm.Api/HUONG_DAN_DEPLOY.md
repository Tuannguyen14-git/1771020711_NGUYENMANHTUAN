# 🚀 HƯỚNG DẪN DEPLOY BACKEND LÊN RENDER.COM

## 📌 Giới Thiệu

Hướng dẫn này sẽ giúp bạn deploy backend API (ASP.NET Core) lên Render.com **HOÀN TOÀN MIỄN PHÍ** để test app APK từ bất kỳ đâu.

**Ưu điểm Render Free Tier:**
- ✅ Miễn phí vĩnh viễn (không cần credit card)
- ✅ Database PostgreSQL 256MB miễn phí
- ✅ 750 giờ runtime mỗi tháng (đủ chạy 24/7)
- ⚠️ App sẽ "ngủ" sau 15 phút không dùng
- ⚠️ Lần đầu gọi API sau khi ngủ sẽ mất 30-60 giây

---

## 🎯 BƯỚC 1: PUSH CODE LÊN GITHUB

### 1.1. Kiểm tra Git status

Mở PowerShell tại folder project:

```powershell
cd c:\HocTap\MOBILE_FLUTTER_1771020711_NguyenManhTuan
git status
```

### 1.2. Add và commit các thay đổi mới

```powershell
# Thêm tất cả file mới
git add .

# Commit với message
git commit -m "Them cau hinh deploy Render"

# Push lên GitHub
git push origin main
```

> **🔍 Lưu ý**: GitHub repository của bạn:
> - **URL**: https://github.com/Tuannguyen14-git/1771020711_NGUYENMANHTUAN.git
> - **Branch**: main

### 1.3. Xác nhận code đã lên GitHub

Vào trình duyệt, mở:
```
https://github.com/Tuannguyen14-git/1771020711_NGUYENMANHTUAN
```

Kiểm tra xem folder `Pcm.Api` có những file mới:
- ✅ `Dockerfile`
- ✅ `.gitignore`
- ✅ `render.yaml`

---

## 🎯 BƯỚC 2: TẠO TÀI KHOẢN RENDER

### 2.1. Truy cập Render.com

Mở trình duyệt, vào: **https://render.com**

### 2.2. Đăng ký tài khoản

**Cách 1: Dùng GitHub (Khuyến nghị)** ⭐
1. Click **"Get Started for Free"**
2. Click **"Sign up with GitHub"**
3. Đăng nhập GitHub nếu chưa đăng nhập
4. Cho phép Render truy cập GitHub của bạn

**Cách 2: Dùng Email**
1. Click **"Get Started for Free"**
2. Điền email và password
3. Xác nhận email

> **✅ Hoàn toàn MIỄN PHÍ** - Không cần nhập thẻ tín dụng!

### 2.3. Xác nhận đăng nhập thành công

Sau khi đăng nhập, bạn sẽ thấy **Render Dashboard**:
```
https://dashboard.render.com/
```

---

## 🎯 BƯỚC 3: TẠO DATABASE POSTGRESQL

### 3.1. Tạo Database mới

Từ Render Dashboard:

1. Click nút **"New +"** ở góc trên bên phải
2. Chọn **"PostgreSQL"**

### 3.2. Điền thông tin Database

Trong form tạo database:

| Thông tin | Giá trị điền vào |
|-----------|------------------|
| **Name** | `pcm-db` |
| **Database** | `pcm_database` |
| **User** | *(để mặc định - auto generate)* |
| **Region** | **Singapore** ⭐ (gần Việt Nam nhất) |
| **PostgreSQL Version** | **16** (mặc định) |
| **Datadog API Key** | *(để trống)* |
| **Plan** | **Free** ✅ |

### 3.3. Tạo Database

1. Scroll xuống dưới cùng
2. Click nút **"Create Database"** (nút màu xanh)

### 3.4. Đợi Database được tạo

- Trạng thái sẽ là **"Creating..."** (màu vàng)
- Đợi khoảng **30-60 giây**
- Khi xong, trạng thái đổi thành **"Available"** (màu xanh)

### 3.5. LƯU LẠI Connection String (QUAN TRỌNG!) 🔑

Sau khi database tạo xong:

1. Scroll xuống phần **"Connections"**
2. Tìm mục **"Internal Database URL"**
3. Click vào **icon copy** (📋) để copy URL

**URL sẽ có dạng:**
```
postgres://pcm_db_user:ABC123xyz...@dpg-abc123-a.singapore-postgres.render.com/pcm_database
```

> **⚠️ QUAN TRỌNG**: Lưu URL này vào Notepad hoặc đâu đó. Sẽ cần dùng ở bước sau!

---

## 🎯 BƯỚC 4: TẠO WEB SERVICE (BACKEND API)

### 4.1. Tạo Web Service mới

Từ Render Dashboard:

1. Click nút **"New +"** ở góc trên
2. Chọn **"Web Service"**

### 4.2. Kết nối GitHub Repository

**Nếu bạn đăng nhập bằng GitHub:**
- Render sẽ tự động hiển thị danh sách repositories
- Tìm repository: **`Tuannguyen14-git/1771020711_NGUYENMANHTUAN`**
- Click **"Connect"**

**Nếu bạn đăng nhập bằng Email:**
1. Click **"Connect account"** → Chọn **GitHub**
2. Đăng nhập GitHub và authorize Render
3. Tìm repository: **`Tuannguyen14-git/1771020711_NGUYENMANHTUAN`**
4. Click **"Connect"**

### 4.3. Điền thông tin Web Service

Sau khi connect repository thành công:

| Thông tin | Giá trị điền vào |
|-----------|------------------|
| **Name** | `pcm-api` *(hoặc tên bạn thích)* |
| **Region** | **Singapore** ⭐ |
| **Branch** | `main` |
| **Root Directory** | `Pcm.Api` ⚠️ |
| **Environment** | **Docker** ⭐ |
| **Docker Command** | *(để trống - sẽ dùng Dockerfile)* |

> **⚠️ LƯU Ý**: 
> - **Root Directory** phải là `Pcm.Api` (chính xác, có chữ hoa)
> - **Environment** phải chọn **Docker** (vì ta đã tạo Dockerfile)

### 4.4. Chọn Plan

Scroll xuống phần **"Instance Type"** hoặc **"Plan"**:

- Chọn **"Free"** ✅
- **$0/month** - Miễn phí!

### 4.5. Cấu hình Environment Variables (QUAN TRỌNG!) 🔑

Scroll xuống phần **"Environment Variables"** hoặc **"Advanced"** → **"Environment Variables"**

Click **"Add Environment Variable"** và thêm các biến sau:

#### Biến 1: ASPNETCORE_ENVIRONMENT
- **Key**: `ASPNETCORE_ENVIRONMENT`
- **Value**: `Production`

#### Biến 2: UsePostgreSQL
- **Key**: `UsePostgreSQL`
- **Value**: `true`

#### Biến 3: DATABASE_URL ⭐ (QUAN TRỌNG!)
- **Key**: `DATABASE_URL`
- **Value**: *(Paste URL bạn đã copy ở Bước 3.5)*

**Ví dụ:**
```
postgres://pcm_db_user:ABC123xyz...@dpg-abc123-a.singapore-postgres.render.com/pcm_database
```

#### Biến 4: Jwt__Key
- **Key**: `Jwt__Key`
- **Value**: `PCM_SECRET_KEY_SUPER_LONG_32_CHARS_123456`

#### Biến 5: Jwt__Issuer
- **Key**: `Jwt__Issuer`
- **Value**: `Pcm.Api`

#### Biến 6: Jwt__Audience
- **Key**: `Jwt__Audience`
- **Value**: `Pcm.Mobile`

#### Biến 7: Jwt__ExpireMinutes
- **Key**: `Jwt__ExpireMinutes`
- **Value**: `120`

**Tổng cộng: 7 environment variables**

### 4.6. Tạo Web Service

1. Scroll xuống dưới cùng
2. Click nút **"Create Web Service"** (nút màu xanh lớn)

---

## 🎯 BƯỚC 5: CHỜ DEPLOY HOÀN TẤT

### 5.1. Theo dõi quá trình deploy

Sau khi click "Create Web Service":

- Render sẽ chuyển đến trang **Logs**
- Bạn sẽ thấy logs realtime của quá trình build

### 5.2. Các giai đoạn deploy

**Giai đoạn 1: Cloning repository** (30 giây)
```
==> Cloning from https://github.com/...
```

**Giai đoạn 2: Building Docker image** (5-8 phút) ⏱️
```
==> Building...
#1 [internal] load build definition from Dockerfile
#2 [internal] load .dockerignore
...
```

**Giai đoạn 3: Starting service** (30 giây)
```
==> Starting service...
```

**Giai đoạn 4: Deploy thành công!** ✅
```
==> Your service is live 🎉
```

### 5.3. Tổng thời gian đợi

- **Lần đầu**: Khoảng **8-12 phút** (build Docker image lần đầu)
- **Lần sau**: Nhanh hơn nhờ Docker cache

> **💡 Mẹo**: Trong lúc đợi, bạn có thể đọc tiếp các bước sau để chuẩn bị!

---

## 🎯 BƯỚC 6: LẤY URL CỦA API

### 6.1. Tìm URL của service

Sau khi deploy thành công:

1. Ở đầu trang Render Dashboard, bạn sẽ thấy tên service: **pcm-api** (hoặc tên bạn đặt)
2. Bên dưới tên sẽ có URL màu xanh, dạng:

```
https://pcm-api.onrender.com
```

> **Nếu bạn đặt tên khác**, URL sẽ là:
> ```
> https://TEN-BAN-DAT.onrender.com
> ```

### 6.2. Sao chép URL

Click vào **icon copy** hoặc bôi đen và copy URL này.

**LƯU LẠI URL NÀY** - Sẽ cần dùng để update Flutter app!

---

## 🎯 BƯỚC 7: KIỂM TRA API HOẠT ĐỘNG

### 7.1. Test Swagger UI

Mở trình duyệt, truy cập:

```
https://pcm-api.onrender.com/swagger
```

*(Thay `pcm-api` bằng tên service của bạn)*

**Nếu thấy trang Swagger UI** → ✅ API đã hoạt động!

> **⚠️ Lưu ý**: Lần đầu tiên truy cập có thể mất **30-60 giây** vì app đang "thức dậy" (cold start).

### 7.2. Test API endpoint

Trong Swagger UI:

1. Tìm endpoint **`GET /api/Members`**
2. Click **"Try it out"**
3. Click **"Execute"**

**Kết quả mong đợi:**
- **Response Code 200** hoặc **Response Code 401** (chưa login) → OK ✅
- Hoặc return `[]` (array rỗng - database chưa có data) → OK ✅

**Nếu có lỗi database connection:**
- Kiểm tra lại `DATABASE_URL` trong Environment Variables
- Xem logs để debug

---

## 🎯 BƯỚC 8: CẬP NHẬT FLUTTER APP

Bây giờ update app Flutter để kết nối với API production.

### 8.1. Mở file constants.dart

Đường dẫn:
```
c:\HocTap\MOBILE_FLUTTER_1771020711_NguyenManhTuan\pcm_mobile\lib\core\constants.dart
```

### 8.2. Thay đổi URL

**Code cũ:**
```dart
class Constants {
  static String get baseUrl {
    if (kIsWeb) return 'https://localhost:7043';
    return 'https://192.168.1.245:7043';
  }

  static String get signalRHubUrl {
    if (kIsWeb) return 'https://localhost:7043/pcmHub';
    return 'https://10.0.2.2:7043/pcmHub';
  }
}
```

**Code mới (thay ĐỔI):**
```dart
class Constants {
  static String get baseUrl {
    if (kIsWeb) return 'https://pcm-api.onrender.com';
    return 'https://pcm-api.onrender.com';  // ⭐ Thay bằng URL của bạn
  }

  static String get signalRHubUrl {
    if (kIsWeb) return 'https://pcm-api.onrender.com/pcmHub';
    return 'https://pcm-api.onrender.com/pcmHub';  // ⭐ Thay bằng URL của bạn
  }
}
```

> **⚠️ QUAN TRỌNG**: Thay `pcm-api.onrender.com` bằng URL thực tế của bạn từ Bước 6!

### 8.3. Lưu file

Nhấn **Ctrl + S** để lưu file.

---

## 🎯 BƯỚC 9: BUILD LẠI APK

### 9.1. Mở PowerShell tại folder Flutter

```powershell
cd c:\HocTap\MOBILE_FLUTTER_1771020711_NguyenManhTuan\pcm_mobile
```

### 9.2. Build APK mới

```powershell
flutter build apk --release
```

### 9.3. Đợi build hoàn tất

- Thời gian: Khoảng **5-10 phút** (nhanh hơn lần đầu)
- Build success sẽ hiện:

```
✓ Built build\app\outputs\flutter-apk\app-release.apk (XX.X MB).
```

### 9.4. Lấy file APK

File APK mới nằm ở:
```
c:\HocTap\MOBILE_FLUTTER_1771020711_NguyenManhTuan\pcm_mobile\build\app\outputs\flutter-apk\app-release.apk
```

---

## 🎯 BƯỚC 10: TEST APK VỚI API PRODUCTION

### 10.1. Cài đặt APK lên điện thoại

1. Copy file **app-release.apk** vào điện thoại
2. Cài đặt APK (cho phép "Install from Unknown Sources" nếu cần)

### 10.2. Mở app và test

**Test 1: Đợi app thức dậy (lần đầu)**
- Mở app lần đầu
- **Đợi 30-60 giây** nếu API đang ngủ
- Bạn có thể thấy loading lâu → Bình thường!

**Test 2: Login**
1. Thử đăng nhập với tài khoản
2. Nếu chưa có tài khoản, tạo tài khoản mới qua app

**Test 3: Các chức năng khác**
- Test booking, wallet, tournaments, v.v.
- Tất cả đều sẽ call API production trên Render

### 10.3. Lưu ý về performance

- **Lần đầu sau khi ngủ**: Chậm (30-60s)
- **Sau khi thức dậy**: Bình thường
- **App ngủ lại sau**: 15 phút không dùng

---

## 📊 THEO DÕI VÀ QUẢN LÝ

### Xem Logs

1. Vào Render Dashboard
2. Click vào service **pcm-api**
3. Tab **"Logs"** → Xem logs real-time

### Xem Database

1. Click vào database **pcm-db**
2. Tab **"Info"** → Copy **External Database URL**
3. Dùng pgAdmin hoặc DBeaver để connect và xem data

### Restart Service

Nếu cần restart:
1. Vào service **pcm-api**
2. Click **"Manual Deploy"** → **"Clear build cache & deploy"**

---

## ⚠️ TROUBLESHOOTING (XỬ LÝ LỖI)

### Lỗi 1: "Build failed"

**Nguyên nhân**: Dockerfile hoặc code có lỗi

**Cách fix**:
1. Xem logs chi tiết trong Render
2. Fix lỗi trong code
3. Push lại lên GitHub
4. Render sẽ tự động deploy lại

### Lỗi 2: "Application failed to respond"

**Nguyên nhân**: App crash khi start

**Cách fix**:
1. Xem logs để tìm error message
2. Có thể do:
   - Database connection string sai
   - Thiếu environment variables
   - Migration lỗi

### Lỗi 3: Flutter app không kết nối được API

**Nguyên nhân**: URL sai hoặc CORS

**Cách fix**:
1. Kiểm tra URL trong `constants.dart` có đúng không
2. Kiểm tra CORS trong backend (đã config `AllowAll`)
3. Thử truy cập Swagger trên browser trước

### Lỗi 4: Database connection failed

**Nguyên nhân**: `DATABASE_URL` sai

**Cách fix**:
1. Vào database dashboard, copy lại **Internal Database URL**
2. Update environment variable `DATABASE_URL` trong web service
3. Restart service

---

## 🎯 CÁC BƯỚC TƯƠNG LAI (TÙY CHỌN)

### 1. Setup Auto Database Migration

Thêm vào `Program.cs` (trước `app.Run()`):

```csharp
// Tự động chạy migrations khi app start
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<PcmDbContext>();
    db.Database.Migrate();
}

app.Run();
```

### 2. Setup Keep-Alive (Tránh app ngủ)

**Option 1: Dùng cron-job.org** (Miễn phí)
1. Tạo account tại https://cron-job.org
2. Tạo cronjob mới:
   - URL: `https://pcm-api.onrender.com/swagger`
   - Interval: Every 14 minutes
3. Enable

**Option 2: Dùng UptimeRobot** (Miễn phí)
1. Tạo account tại https://uptimerobot.com
2. Add monitor:
   - URL: `https://pcm-api.onrender.com/swagger`
   - Interval: 5 minutes

### 3. Seed Data vào Database

Tạo admin account và test data:
1. Vào Swagger UI
2. POST `/api/Auth/register` để tạo user
3. POST data mẫu cho courts, tournaments, etc.

---

## 📋 CHECKLIST HOÀN THÀNH

- [ ] **Bước 1**: Push code lên GitHub
- [ ] **Bước 2**: Tạo tài khoản Render
- [ ] **Bước 3**: Tạo PostgreSQL database
- [ ] **Bước 4**: Tạo Web Service và config env vars
- [ ] **Bước 5**: Đợi deploy xong
- [ ] **Bước 6**: Lấy API URL
- [ ] **Bước 7**: Test Swagger UI
- [ ] **Bước 8**: Update constants.dart
- [ ] **Bước 9**: Build lại APK
- [ ] **Bước 10**: Test APK với API production

---

## 🎉 KẾT LUẬN

**Chúc mừng!** Bạn đã deploy thành công backend API lên Render.com!

**Tổng kết:**
- ✅ API chạy 24/7 miễn phí
- ✅ Database PostgreSQL miễn phí
- ✅ APK có thể test từ bất kỳ đâu
- ✅ Không tốn tiền!

**Hạn chế:**
- ⚠️ App ngủ sau 15 phút (chấp nhận được cho testing)
- ⚠️ Database 256MB (đủ cho test)

**Nếu cần nâng cấp sau này:**
- Render có paid plans bắt đầu từ $7/tháng
- Hoặc có thể chuyển sang Railway, Azure, AWS

---

**📞 Cần hỗ trợ?**
- Render Docs: https://render.com/docs
- Render Community: https://community.render.com/

**Good luck!** 🚀
