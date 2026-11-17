# Prusa Connect (Self-Hosted) — Unraid Docker Template

<p align="center">
  <img src="https://raw.githubusercontent.com/Kikkawaryu/prusa-connect-unraid/main/PrusaConnect.png" alt="Prusa Connect Logo" width="128" />
</p>

Unraid Community Applications template and automated Docker image for the self-hosted local version of [Prusa Connect](https://github.com/prusa3d/prusa-connect).

Everything runs locally on your own network with no cloud connection required. It works natively with Prusa printers (firmware 6.4.0+) and supports third-party printers (such as Klipper via Moonraker) and extensions.

## Links
- **Docker Image:** `ghcr.io/kikkawaryu/prusa-connect:latest`
- **Template Repository:** https://github.com/Kikkawaryu/prusa-connect-unraid
- **Upstream Project:** https://github.com/prusa3d/prusa-connect
- **Unraid Support Thread:** https://forums.unraid.net/ (replace with your direct thread link if desired)

## Installation on Unraid
1. Open the **Apps** tab in Unraid and search for **prusa-connect**.
2. Click **Install**.
3. If port `8080` is already in use on your server (e.g., by qBittorrent or SABnzbd), change the **WebUI Port** to an available port such as `8085`.
4. Click **Apply** to pull the image and start the container.

## First-Time Setup
1. **Retrieve your one-time setup code:**
   After starting the container for the first time, open the container **Logs** in Unraid and look for:
   ```text
   setup_code=XXXX-XXXX-XXXX
   ```
2. **Create your admin account:**
   Open the WebUI (`http://<UNRAID-IP>:8080`) in your browser and enter the setup code when prompted.
3. **Connect a printer:**
   - In the Prusa Connect WebUI, click **Add a Printer** and download the generated settings `.ini` file.
   - Copy the `.ini` file to the root of a USB drive.
   - Insert the USB drive into your printer and navigate to **Settings → Network → Prusa Connect → Load settings**.

## Default Ports & Volume Mappings

| Parameter | Default Host Value | Container Path / Port | Description |
| :--- | :--- | :--- | :--- |
| **WebUI Port** | `8080` | `8080/tcp` | Web interface and printer API port |
| **Config** | `/mnt/user/appdata/prusa-connect/config` | `/config` | Stores `config.yaml` and `config.d` overrides |
| **Data** | `/mnt/user/appdata/prusa-connect/data` | `/data` | SQLite database and application state |
| **Files** | `/mnt/user/appdata/prusa-connect/files` | `/files` | Uploaded print files and G-code |
| **Storage** | `/mnt/user/appdata/prusa-connect/storage` | `/storage` | Persistent storage assets |

## Permissions & Configuration Notes
- The container automatically initializes `/config/config.yaml` on first boot if it does not already exist and runs the service under UID/GID `10001:10001`.
- Ensure your appdata volume mappings are set to **Read/Write** so the entrypoint script can initialize directories and permissions cleanly.

## Automated Builds
This repository includes a GitHub Actions workflow (`.github/workflows/build.yml`) that checks `prusa3d/prusa-connect` every 12 hours for new upstream releases, compiles the multi-stage image, and publishes both `:latest` and the matching release tag to GitHub Container Registry (`ghcr.io`).
