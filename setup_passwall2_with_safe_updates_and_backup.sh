#!/bin/sh
# تنظیم Passwall2 + آپدیت امن GeoIP/GeoSite + بکاپ خودکار تنظیمات (سازگار با BusyBox/ash)

set -e

# ===== تنظیمات =====
DEFAULT_NODE="proxy"
SRC_ZONE="lan"
ENABLE_POLICY="1"
CRON_TIME="0 4 * * *"              # هر روز ۴ صبح
TMP_DIR="/tmp/passwall2_updates"
DATA_DIR="/usr/share/passwall2"
BACKUP_DIR="/root/passwall2_backups"
# دیتاست کامل (شامل همه کشورها) تا geoip:ir کار کند
GEOIP_URL="https://github.com/Loyalsoldier/geoip/raw/release/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat"
# ====================

mkdir -p "$TMP_DIR" "$DATA_DIR" "$BACKUP_DIR"

# --- بررسی سرویس ---
if [ ! -x /etc/init.d/passwall2 ]; then
  echo "[-] سرویس passwall2 پیدا نشد!"
  exit 1
fi

# --- تنظیم global ---
if ! uci -q get passwall2.@global[0] >/dev/null; then
  uci add passwall2 global >/dev/null
fi
uci set passwall2.@global[0].policy_enable="$ENABLE_POLICY"
uci set passwall2.@global[0].default_node="$DEFAULT_NODE"

# --- حذف قوانین هدف (بدون دست زدن به بقیه) ---
for NAME in Iran_IP Iran_GeoSite Iran_Regex; do
  for SEC in $(uci -q show passwall2 | grep -E "^passwall2\.@rule

\[[0-9]+\]

\.name='$NAME'" | cut -d= -f1 | cut -d. -f1-3); do
    uci delete "$SEC"
  done
done

# --- قوانین جدید ---
uci add passwall2 rule >/dev/null
uci set passwall2.@rule[-1].name='Iran_IP'
uci set passwall2.@rule[-1].enabled='1'
uci set passwall2.@rule[-1].src="$SRC_ZONE"
uci set passwall2.@rule[-1].ip='geoip:ir'
uci set passwall2.@rule[-1].action='direct'

uci add passwall2 rule >/dev/null
uci set passwall2.@rule[-1].name='Iran_GeoSite'
uci set passwall2.@rule[-1].enabled='1'
uci set passwall2.@rule[-1].src="$SRC_ZONE"
uci set passwall2.@rule[-1].domain='geosite:ir'
uci set passwall2.@rule[-1].action='direct'

uci add passwall2 rule >/dev/null
uci set passwall2.@rule[-1].name='Iran_Regex'
uci set passwall2.@rule[-1].enabled='1'
uci set passwall2.@rule[-1].src="$SRC_ZONE"
uci set passwall2.@rule[-1].domain='regexp:^.+\.ir$'
uci set passwall2.@rule[-1].action='direct'

uci commit passwall2

# --- تابع آپدیت امن ---
update_geo_files() {
  local TMP_GEOIP="$TMP_DIR/geoip.dat"
  local TMP_GEOSITE="$TMP_DIR/geosite.dat"

  echo "[*] دانلود GeoIP..."
  if curl -fsSL "$GEOIP_URL" -o "$TMP_GEOIP" && [ -s "$TMP_GEOIP" ]; then
    mv "$TMP_GEOIP" "$DATA_DIR/geoip.dat"
    echo "[✓] GeoIP آپدیت شد."
  else
    echo "[!] دانلود GeoIP ناموفق، نسخهٔ قبلی نگه داشته شد."
    rm -f "$TMP_GEOIP"
  fi

  echo "[*] دانلود GeoSite..."
  if curl -fsSL "$GEOSITE_URL" -o "$TMP_GEOSITE" && [ -s "$TMP_GEOSITE" ]; then
    mv "$TMP_GEOSITE" "$DATA_DIR/geosite.dat"
    echo "[✓] GeoSite آپدیت شد."
  else
    echo "[!] دانلود GeoSite ناموفق، نسخهٔ قبلی نگه داشته شد."
    rm -f "$TMP_GEOSITE"
  fi
}

# --- تابع بکاپ‌گیری ---
backup_passwall2() {
  local DATE_TAG
  DATE_TAG=$(date +"%Y%m%d_%H%M%S")
  local BACKUP_FILE="$BACKUP_DIR/passwall2_backup_$DATE_TAG.tar.gz"
  echo "[*] بکاپ‌گیری از تنظیمات..."
  tar -czf "$BACKUP_FILE" /etc/config/passwall2 "$DATA_DIR"/geo*.dat 2>/dev/null || true
  echo "[✓] بکاپ ذخیره شد: $BACKUP_FILE"

  # نگه‌داشتن فقط 10 بکاپ آخر
  CNT=0
  for f in $(ls -t "$BACKUP_DIR"/passwall2_backup_*.tar.gz 2>/dev/null); do
    CNT=$((CNT+1))
    [ "$CNT" -le 10 ] && continue
    rm -f "$f"
  done
}

# --- اجرای اولیه ---
update_geo_files
backup_passwall2
/etc/init.d/passwall2 restart

# --- ساخت اسکریپت زمان‌بندی (بدون وابستگی به typeset) ---
cat > "$DATA_DIR/update_and_backup.sh" <<'EOF'
#!/bin/sh
set -e
TMP_DIR="/tmp/passwall2_updates"
DATA_DIR="/usr/share/passwall2"
BACKUP_DIR="/root/passwall2_backups"
GEOIP_URL="https://github.com/Loyalsoldier/geoip/raw/release/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat"
mkdir -p "$TMP_DIR" "$DATA_DIR" "$BACKUP_DIR"

update_geo_files() {
  local TMP_GEOIP="$TMP_DIR/geoip.dat"
  local TMP_GEOSITE="$TMP_DIR/geosite.dat"

  if curl -fsSL "$GEOIP_URL" -o "$TMP_GEOIP" && [ -s "$TMP_GEOIP" ]; then
    mv "$TMP_GEOIP" "$DATA_DIR/geoip.dat"
  else
    rm -f "$TMP_GEOIP"
  fi

  if curl -fsSL "$GEOSITE_URL" -o "$TMP_GEOSITE" && [ -s "$TMP_GEOSITE" ]; then
    mv "$TMP_GEOSITE" "$DATA_DIR/geosite.dat"
  else
    rm -f "$TMP_GEOSITE"
  fi
}

backup_passwall2() {
  local DATE_TAG
  DATE_TAG=$(date +"%Y%m%d_%H%M%S")
  local BACKUP_FILE="$BACKUP_DIR/passwall2_backup_$DATE_TAG.tar.gz"
  tar -czf "$BACKUP_FILE" /etc/config/passwall2 "$DATA_DIR"/geo*.dat 2>/dev/null || true

  CNT=0
  for f in $(ls -t "$BACKUP_DIR"/passwall2_backup_*.tar.gz 2>/dev/null); do
    CNT=$((CNT+1))
    [ "$CNT" -le 10 ] && continue
    rm -f "$f"
  done
}

update_geo_files
backup_passwall2
/etc/init.d/passwall2 restart
EOF
chmod +x "$DATA_DIR/update_and_backup.sh"

# --- افزودن کران‌جاب در OpenWrt (idempotent) ---
CRON_FILE="/etc/crontabs/root"
LINE="$CRON_TIME /bin/sh $DATA_DIR/update_and_backup.sh"

mkdir -p /etc/crontabs
touch "$CRON_FILE"
grep -Fq "$DATA_DIR/update_and_backup.sh" "$CRON_FILE" || echo "$LINE" >> "$CRON_FILE"
/etc/init.d/cron enable >/dev/null 2>&1 || true
/etc/init.d/cron restart >/dev/null 2>&1 || /etc/init.d/cron reload >/dev/null 2>&1 || true

echo "[✓] آماده: قوانین اعمال شد، آپدیت امن زمان‌بندی شد و بکاپ‌گیری خودکار فعال است."
