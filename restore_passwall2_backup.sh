#!/bin/sh
# بازگردانی بکاپ Passwall2 با منوی انتخابی (سازگار با BusyBox/ash)

BACKUP_DIR="/root/passwall2_backups"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "[-] پوشهٔ بکاپ پیدا نشد: $BACKUP_DIR"
  exit 1
fi

# فهرست بکاپ‌ها (جدیدترین ابتدا)
BACKUPS="$(ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null)"
if [ -z "$BACKUPS" ]; then
  echo "[-] هیچ بکاپی پیدا نشد."
  exit 1
fi

echo "=== لیست بکاپ‌های موجود ==="
i=1
for f in $BACKUPS; do
  echo "[$i] $(basename "$f")"
  i=$((i+1))
done
echo "==========================="

printf "شمارهٔ بکاپ موردنظر را وارد کنید: "
read choice

# اعتبارسنجی عدد
case "$choice" in
  ''|*[!0-9]*)
    echo "[-] انتخاب نامعتبر."
    exit 1
    ;;
esac

count=$(echo "$BACKUPS" | wc -l)
if [ "$choice" -lt 1 ] || [ "$choice" -gt "$count" ]; then
  echo "[-] انتخاب خارج از محدوده."
  exit 1
fi

i=1
SELECTED_FILE=""
for f in $BACKUPS; do
  if [ "$i" -eq "$choice" ]; then
    SELECTED_FILE="$f"
    break
  fi
  i=$((i+1))
done

if [ -z "$SELECTED_FILE" ] || [ ! -f "$SELECTED_FILE" ]; then
  echo "[-] فایل انتخاب‌شده معتبر نیست."
  exit 1
fi

echo "[*] بازگردانی از بکاپ: $(basename "$SELECTED_FILE")"
tar -xzf "$SELECTED_FILE" -C /

echo "[*] اعمال تنظیمات..."
/etc/init.d/passwall2 restart

echo "[✓] بازگردانی کامل شد."
