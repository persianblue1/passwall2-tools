# Passwall Routing & Backup Tools 🇮🇷

Automated scripts for smart routing configuration in Passwall2, secure GeoIP/GeoSite updates, and backup/restore of settings on OpenWrt.

---

## 📦 Files

| File | Description |
|------|-------------|
| `setup_passwall2_with_safe_updates_and_backup.sh` | Configures Iran routing rules + safely updates GeoIP/GeoSite + daily backup |
| `restore_passwall2_backup.sh` | Interactive restore from latest backups with menu selection |

---

## ⚙️ Installation & Usage

### 1. Initial Setup

```bash
sh setup_passwall2_with_safe_updates_and_backup.sh
This script will:

Configure routing rules for Iranian IPs and domains

Download GeoIP and GeoSite databases from trusted sources

Backup current Passwall2 settings and databases

Add a daily cron job for auto-update and backup

Keep only the latest 10 backups to save space

Backup path: /root/passwall2_backups/ Database path: /usr/share/passwall2/

🔁 Restore from Backup
To restore a previous backup:

bash
sh restore_passwall2_backup.sh
You'll see a list of available backups. Enter the number to restore settings and databases. Passwall2 will restart automatically.

🧠 Key Features
If GeoIP or GeoSite download fails, the previous version is retained to avoid service disruption.

Direct routing is applied for:

Iranian IPs (GeoIP)

Iranian domains (GeoSite)

Domains ending in .ir (Regex)

All other traffic is routed via the default node (e.g., VPN).

📜 Requirements
OpenWrt with luci-app-passwall2 installed

Passwall2 service enabled

Root access to run scripts

curl and tar installed (usually pre-installed on OpenWrt)

🧰 Developer
GitHub: persianblue1

Repository: passwall-routing-and-backup

📬 Feedback & Issues
Feel free to open an issue in this repository for suggestions or bug reports.
