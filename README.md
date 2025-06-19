# 🛠️ Pi Recovery Menu

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi-lightgrey)](https://www.raspberrypi.com/)
[![Shell](https://img.shields.io/badge/script-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![Status](https://img.shields.io/badge/status-active-brightgreen.svg)](https://github.com/yourusername/pi-recovery-menu)

> A modular dialog-based recovery and maintenance menu for Raspberry Pi OS systems, offering safe system recovery, drive management, OS reinstallation, Docker utilities, and more — ideal for headless and emergency setups.

---

## ✨ Features

- 🧭 **System Boot Detection** — Recognizes boot source (SD card or USB).
- 🔌 **Drive Management** — Format, mount, fsck, SMART diagnostics.
- 💽 **Raspberry Pi OS Reinstallation** — Local and online image support.
- 🐳 **Docker Tools** — Container and service controls.
- 🛠 **Pi Tools** — EEPROM recovery, backup, and system tweaks.
- 🌐 **Network Tools** — Diagnose, reset, and reconfigure networking.
- 🔧 **Utilities** — Launch terminal or raspi-config from menu.
- 📦 **Extensible** — Easy to add more modules and categories.

---

## 📁 Project Structure

```
pi-recovery-menu/
├── recovery-menu.sh              # Main menu script
└── scripts/
    ├── docker_tools.sh
    ├── drive_tools.sh
    ├── format_drive.sh
    ├── fsck_menu.sh
    ├── network_tools.sh
    ├── omv_tools.sh
    ├── os_reinstall.sh
    ├── pi_tools.sh
    ├── reinstall_from_local.sh
    ├── reinstall_from_online.sh
    ├── reinstall_os_menu.sh
    ├── smart_menu.sh
    └── symlink_tools.sh
```

---

## 🚀 Installation

```bash
git clone https://github.com/yourusername/pi-recovery-menu.git
cd pi-recovery-menu
chmod +x recovery-menu.sh
./recovery-menu.sh
```

🔁 On first launch, a symlink will be created:
```bash
/usr/local/bin/recovery-menu → /path/to/recovery-menu.sh
```

✅ You can now run the menu from anywhere:
```bash
recovery-menu
```

---

## 📦 Dependencies

Make sure the following packages are installed:

```bash
sudo apt install dialog curl wget smartmontools dosfstools parted util-linux rsync
```

---

## 📋 Menu Options Overview

| Option                 | Description                               |
|------------------------|-------------------------------------------|
| OMV Tools              | Manage OpenMediaVault configs & services |
| Drive Management       | Format, fsck, SMART, mount drives         |
| Reinstall OS           | Reinstall Raspberry Pi OS (local/online)  |
| Docker Tools           | Start/stop containers, view logs          |
| Pi-Specific Tools      | EEPROM flash, backup config, etc.         |
| Network Tools          | Reset DHCP, diagnose interfaces           |
| Open Terminal          | Launch bash shell                         |
| Raspi Config           | Run `raspi-config` interface              |
| Exit                   | Exit the menu                             |

---

## 🧪 Tested On

- ✅ Raspberry Pi 4
- ✅ Works via SSH (headless) and with display

---

## 🙌 Contributing

Pull requests are welcome! If you’d like to contribute:
1. Fork the repo
2. Create a feature branch (`git checkout -b my-feature`)
3. Commit your changes
4. Open a PR describing your changes

---

## 📜 License

This project is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).
