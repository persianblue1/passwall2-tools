# Passwall2 Routing & Backup Tools 🇮🇷

Automated scripts for smart routing in Passwall2, secure GeoIP/GeoSite updates, and backup/restore on OpenWrt.

---

## 🚀 Quick Install

Run this one-liner on your OpenWrt router:

```bash
sh -c 'curl -L -o /tmp/install.sh https://raw.githubusercontent.com/persianblue1/passwall-routing-and-backup/main/install.sh && sh /tmp/install.sh'
```
This will:

Download and install all scripts

Apply initial configuration

Enable secure updates and daily backups

## 📦 Files

| File Name | Description |
|-----------|-------------|
| `setup_passwall2_with_safe_updates_and_backup.sh` | Sets up Iran routing rules + secure GeoIP/GeoSite updates + daily backup |
| `restore_passwall2_backup.sh` | Restores backups via interactive menu |
| `install.sh` | One-step installer for all tools |

⚙️ Manual Usage
Run Setup

```bash
sh /usr/share/passwall2/setup_passwall2_with_safe_updates_and_backup.sh
```
Restore Backup
```bash
sh /usr/share/passwall2/restore_passwall2_backup.sh
```
🧠 Notes
If GeoIP/GeoSite download fails, previous version is preserved.

Direct routing is applied for Iranian IPs and domains.

Only the latest 10 backups are retained.

📜 Requirements
OpenWrt with luci-app-passwall2

Passwall2 service enabled

Root access

curl and tar installed

🧰 Developer
GitHub: persianblue1

Repository: passwall-routing-and-backup

📬 Feedback & Issues
Please open an issue in this repository.
