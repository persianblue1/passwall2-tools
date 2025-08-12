# Passwall Routing & Backup Tools 🇮🇷

ابزارهای خودکار برای تنظیم مسیریابی هوشمند در Passwall2، آپدیت امن پایگاه‌های GeoIP/GeoSite، و بکاپ‌گیری/بازگردانی تنظیمات روی OpenWrt.

---

## 📦 فایل‌ها

| فایل | توضیح |
|------|-------|
| `setup_passwall2_with_safe_updates_and_backup.sh` | تنظیم قوانین برای ایران + دانلود امن GeoIP/GeoSite + بکاپ‌گیری روزانه |
| `restore_passwall2_backup.sh` | بازگردانی بکاپ با منوی انتخابی از آخرین نسخه‌های ذخیره‌شده |

---

## ⚙️ نصب و اجرا

### 1. اجرای اسکریپت تنظیم اولیه

```bash
sh setup_passwall2_with_safe_updates_and_backup.sh
