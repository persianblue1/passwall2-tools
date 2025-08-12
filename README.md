Automated scripts for smart routing configuration in Passwall2, secure updates of GeoIP/GeoSite databases, and backup/restore of settings on OpenWrt.

---

## 📦 Files

| File Name | Description |
|-----------|-------------|
| `setup_passwall2_with_safe_updates_and_backup.sh` | Sets up Iran-specific routing rules + securely downloads GeoIP/GeoSite + enables daily backups |
| `restore_passwall2_backup.sh` | Restores backups with a menu to select from the latest saved versions |

---

## ⚙️ How to Use

### 1. Run the Setup Script
```bash
sh setup_passwall2_with_safe_updates_and_backup.sh
```
This script will:

Configure routing rules for Iranian IPs and domains

Securely download GeoIP and GeoSite databases

Create backups of settings and databases

Add a daily cron job for automatic updates and backups

Keep only the latest 10 backups to save space

Backup path: /root/passwall2_backups/
Database path: /usr/share/passwall2/

🔁 Restore from Backup
To restore a previous backup:
```bash
sh restore_passwall2_backup.sh
```
A list of available backups will be shown. Enter the number to restore settings and databases. The Passwall2 service will automatically restart.

🧠 Key Notes
If GeoIP or GeoSite download fails, the previous version will be preserved to avoid service disruption.

The following rules are applied to route Iranian traffic directly:

Iranian IPs (GeoIP)

Iranian domains (GeoSite)

Domains ending in .ir (Regex)

All other traffic is routed through the default node (e.g., VPN).

📜 Requirements
OpenWrt with luci-app-passwall2 installed

Passwall2 service must be active

Root access to run scripts

curl and tar installed (usually available in OpenWrt)

🧰 Developer
GitHub: persianblue1

Repository: passwall-routing-and-backup

📬 Suggestions or Issues?
If you have ideas to improve the scripts or encounter any issues, feel free to open an Issue in the repository.
