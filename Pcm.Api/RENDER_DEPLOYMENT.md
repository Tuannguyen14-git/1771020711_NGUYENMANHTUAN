# PCM API - Deployment Guide for Render.com

## Prerequisites
- GitHub account
- Render.com account (miễn phí, không cần credit card)

## 🚀 Deployment Steps

### 1. Push Code to GitHub

```bash
# Initialize git if not already done
git init

# Add all files
git add .

# Commit
git commit -m "Prepare for Render deployment"

# Add your GitHub remote repository
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push to GitHub
git push -u origin main
```

### 2. Create PostgreSQL Database on Render

1. Đăng nhập vào [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** → **"PostgreSQL"**
3. Điền thông tin:
   - **Name**: `pcm-db`
   - **Database**: `pcm_database`
   - **Region**: `Singapore` (gần Việt Nam nhất)
   - **Plan**: **Free**
4. Click **"Create Database"**
5. **Lưu lại** `Internal Database URL` (sẽ dùng ở bước sau)

### 3. Create Web Service on Render

1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Điền thông tin:
   - **Name**: `pcm-api`
   - **Region**: `Singapore`
   - **Branch**: `main`
   - **Runtime**: **Docker**
   - **Plan**: **Free**

### 4. Configure Environment Variables

Trong phần **Environment Variables**, thêm các biến sau:

| Key | Value |
|-----|-------|
| `ASPNETCORE_ENVIRONMENT` | `Production` |
| `UsePostgreSQL` | `true` |
| `DATABASE_URL` | *(paste Internal Database URL từ bước 2)* |
| `Jwt__Key` | `PCM_SECRET_KEY_SUPER_LONG_32_CHARS_123456` |
| `Jwt__Issuer` | `Pcm.Api` |
| `Jwt__Audience` | `Pcm.Mobile` |
| `Jwt__ExpireMinutes` | `120` |

### 5. Deploy

1. Click **"Create Web Service"**
2. Render sẽ tự động:
   - Build Docker image từ Dockerfile
   - Deploy app
   - Chạy database migrations
3. Đợi khoảng 5-10 phút để deploy hoàn tất

### 6. Verify Deployment

Sau khi deploy xong, bạn sẽ có URL dạng: `https://pcm-api.onrender.com`

Test API:
```bash
# Test Swagger UI
https://pcm-api.onrender.com/swagger

# Test health
https://pcm-api.onrender.com/api/Members
```

⚠️ **Lưu ý**: Lần đầu tiên truy cập có thể mất 30-60 giây (cold start) vì app đang "ngủ".

---

## 📱 Update Flutter App

Sau khi deploy xong, update `constants.dart` trong Flutter app:

```dart
class Constants {
  static String get baseUrl {
    if (kIsWeb) return 'https://pcm-api.onrender.com';
    return 'https://pcm-api.onrender.com';
  }

  static String get signalRHubUrl {
    if (kIsWeb) return 'https://pcm-api.onrender.com/pcmHub';
    return 'https://pcm-api.onrender.com/pcmHub';
  }
}
```

Rebuild APK:
```bash
cd pcm_mobile
flutter build apk --release
```

---

## 🔧 Database Setup

Database sẽ trống sau khi deploy. Bạn cần:

### Option 1: Tự động migration (đã config trong code)
App sẽ tự động tạo tables khi khởi động lần đầu (nếu có auto-migration)

### Option 2: Manual migration qua Entity Framework
```bash
# Local machine với connection string từ Render
dotnet ef database update --connection "YOUR_POSTGRES_CONNECTION_STRING"
```

### Option 3: Seed data qua API
Tạo tài khoản admin và data test qua Swagger UI

---

## 📊 Monitoring

### Check Logs
1. Vào Render Dashboard
2. Click vào service `pcm-api`
3. Tab **"Logs"** để xem real-time logs

### Check Database
1. Click vào database `pcm-db`
2. Tab **"Info"** → Connect via external tool (pgAdmin, DBeaver, etc.)

---

## ⚠️ Free Tier Limitations

| Feature | Limit |
|---------|-------|
| **App Sleep** | Sau 15 phút không có request |
| **Cold Start** | 30-60 giây để wake up |
| **Database Storage** | 256 MB |
| **Monthly Hours** | 750 hours (đủ chạy cả tháng) |
| **Bandwidth** | 100 GB/month |

### Keep-Alive Strategy (Optional)

Để tránh app ngủ, có thể setup cron job ping API mỗi 14 phút:

**Option 1**: Dùng cron-job.org (free)
- URL: `https://pcm-api.onrender.com/swagger`
- Interval: Every 14 minutes

**Option 2**: Dùng UptimeRobot
- Free tier: 50 monitors
- Check interval: 5 minutes

---

## 🐛 Troubleshooting

### App không start được
- Check Logs trong Render Dashboard
- Verify environment variables
- Check DATABASE_URL format

### Database connection failed
- Verify DATABASE_URL đúng Internal URL
- Check database đang running
- SSL Mode phải là `Require`

### API trả về 500
- Check Logs để xem error details
- Verify migrations đã chạy
- Check CORS settings

---

## 📞 Support

- Render Docs: https://render.com/docs
- Community: https://community.render.com/

---

**🎉 Done! Your API is now live and free!**
