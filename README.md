# Prusa Connect (Self-Hosted) — Unraid Docker Template

Unraid Community Applications template and automated Docker build for the self-hosted local version of [Prusa Connect](https://github.com/prusa3d/prusa-connect).

Everything runs locally on your own network with no cloud connection required. It supports Prusa printers natively (firmware 6.4.0+) as well as third-party printers (such as Klipper via Moonraker) and extensions.

## Links
- **Container Image:** `ghcr.io/kikkawaryu/prusa-connect:latest`
- **Upstream Project:** https://github.com/prusa3d/prusa-connect
- **Unraid Support Thread:** <YOUR_FORUM_SUPPORT_URL>

## Installation on Unraid
1. Open the **Apps** tab in Unraid and search for **prusa-connect**.
2. Click **Install**.
3. If port `8080` is already in use on your server, change the **WebUI Port** to an available port (e.g., `8085`).
4. Click **Apply** to pull and start the container.

## First-Time Setup
1. **Get your one-time setup code:** After starting the container for the first time, open the container **Logs** in Unraid and look for:
   ```text
   setup_code=XXXX-XXXX-XXXX
