# 🧰 K9s Node Disk Usage Plugin

A custom plugin for [k9s](https://k9scli.io) that lets you:

- ✅ View node-level disk usage (capacity, used, available)
- 🎨 See a color-coded usage bar like `[██████░░░░░░░░░░░░░░]`
- 📦 Show the top disk-using pods **on that node**
- 💥 All inside a full-screen k9s popup!

---

## 🚀 Features

- Color-coded disk usage by threshold:
  - 🔴 > 90% — Critical
  - 🟡 > 75% — Warning
  - 🟢 <= 75% — OK
- Visual usage bar
- Pod disk usage ranked in descending order
- Auto-fallback if pods don’t support `sh`
- Safe for minimal containers — no crashing

---

## 📁 Setup

### 1. Clone or copy the plugin files

```bash
mkdir -p ~/.config/k9s/plugins
git clone https://github.com/devops-dude-dinodam/k9s-node-disk-usage-plugin.git
cp k9s-node-disk-usage-plugin/plugins.yaml ~/.config/k9s/plugins.yaml
cp k9s-node-disk-usage-plugin/node-disk.sh ~/.config/k9s/plugins/node-disk.sh
chmod +x ~/.config/k9s/plugins/node-disk.sh
```

### 2. Launch `k9s`, go to `:nodes`, select a node, and press `x`.

---

## 🧪 Example Output

```
Disk Usage for Node: ip-10-30-0-14...

  Capacity : 20.00 GB
  Used     : 6.15 GB (30.75%)
  Available: 13.85 GB
  Usage    : [██████░░░░░░░░░░░░░░]

Top Pods by Disk Usage:

  dev/iot-location-service...         2430.00 MB
  dev/iot-generic-integration...      2180.22 MB
  kube-system/aws-node-xyz            85.55 MB
```

---

## 📦 File Contents

| File | Description |
|------|-------------|
| `plugins.yaml` | The k9s plugin definition |
| `node-disk.sh` | The main script that fetches and displays disk info |
| `LICENSE` | MIT license |
| `README.md` | This file |

---

## 🧠 Notes & Limitations

- Pod disk usage is estimated via `du -s /` inside each container.
- Pods without a shell (`sh`) are skipped gracefully.
- Host-level disk usage per folder (`/var`, `/etc`, etc.) can be added with a privileged DaemonSet (future idea).

---

## 🪪 License

MIT License. See `LICENSE`.

---

## 🙌 Credits

Originally developed by [@dinodam](https://github.com/dinodam)  
Packaging assisted by ChatGPT  
2025

