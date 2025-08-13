#!/bin/sh
# نصب و راه‌اندازی سریع Passwall2 Routing & Backup

set -e

INSTALL_DIR="/usr/share/passwall2"

echo "[*] ساخت مسیر نصب در ${INSTALL_DIR}..."
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "[*] دانلود اسکریپت‌ها از GitHub..."
curl -L -o setup_passwall2_with_safe_updates_and_backup.sh \
https://raw.githubusercontent.com/persianblue1/passwall-routing-and-backup/main/setup_passwall2_with_safe_updates_and_backup.sh

curl -L -o restore_passwall2_backup.sh \
https://raw.githubusercontent.com/persianblue1/passwall-routing-and-backup/main/restore_passwall2_backup.sh

echo "[*] دادن مجوز اجرا به اسکریپت‌ها..."
chmod +x setup_passwall2_with_safe_updates_and_backup.sh restore_passwall2_backup.sh

echo "[*] اجرای اسکریپت تنظیم اولیه..."
sh setup_passwall2_with_safe_updates_and_backup.sh

echo "[✓] نصب و پیکربندی کامل شد!"
echo "برای بازگردانی بکاپ در آینده، اجرا کنید:"
echo "sh ${INSTALL_DIR}/restore_passwall2_backup.sh"
