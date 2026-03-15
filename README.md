This repository contains a streamlined, persistent VS Code environment designed to run on [Railway](https://railway.com/). It features automatic volume permission handling, a 15-minute idle timeout, and telemetry disabled for privacy based on [coder's Github repo](https://github.com/coder/deploy-code-server).

## 🚀 Features

* **Persistence:** Uses Railway Volumes mounted at `/home/coder/project`.
* **Auto-Permissions:** The `entrypoint.sh` automatically ensures the `coder` user owns the volume on boot.
* **Privacy:** Telemetry is disabled via startup flags.
* **Efficiency:** 15-minute idle timeout (`900s`) to manage session lifecycle.
* **Modern Base:** Built on `code-server:4.111.0-39`.

---

## 🛠 Setup & Deployment

### 1. Railway Volume
1.  In your Railway project, click **+ New** > **Volume**.
2.  Mount the volume to your service.
3.  Set the **Mount Path** to: `/home/coder/project`

### 2. Environment Variables
Add the following variables in the **Variables** tab of your Railway service:

| Variable | Value | Description |
| :--- | :--- | :--- |
| `PORT` | `8080` | Internal port for code-server. |
| `PASSWORD` | `your_secret_password` | The password to log into the IDE. |
| `START_DIR` | `/home/coder/project` | Matches your Volume mount path. |

### 3. Networking
* Go to **Settings** > **Public Networking**.
* Click **Generate Domain** to get your `https://...` access link.
