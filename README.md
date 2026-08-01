# 🎮 8bitCityChamp - Infrastructure as Code (IaC) & CI/CD Pipeline

An Infrastructure as Code (IaC) project built with **Terraform** and **GitHub Actions** to automatically deploy a 16-bit Super Nintendo (SNES) style arcade fighting game (**Urban Champion 16-Bit Edition**) on **Google Cloud Platform (GCP)** using a Compute Engine instance (`e2-micro`).

---

## 📌 Architecture & Provisioned Resources

All GCP infrastructure resources are managed via Terraform using the `v8bitcitychamp` prefix:

- **Compute Engine VM**: `v8bitcitychamp-vm` (`e2-micro`, Debian 12 OS)
- **Dedicated VPC**: `v8bitcitychamp-vpc`
- **Subnet**: `v8bitcitychamp-subnet` (`10.0.1.0/24`)
- **Firewall Rules**:
  - `v8bitcitychamp-firewall-http` (Port 80 HTTP, target tag: `v8bitcitychamp-web`)
  - `v8bitcitychamp-firewall-ssh` (Port 22 SSH, target tag: `v8bitcitychamp-web`)
- **Static Public External IP**: `v8bitcitychamp-ip`
- **Automated Web Provisioning**: `scripts/startup.sh` injected via `metadata_startup_script` installs Nginx and deploys the 16-bit SNES arcade fighting game.

---

## 🕹️ Feature2 16-Bit Arcade Game Enhancements

- **16-Bit SNES Graphic Overhaul**:
  - Detailed character models with muscle shading, face expressions, leather boots, vest textures, and distinct gear.
  - **Blood Splatter & Hit FX**: Dynamic 16-bit blood particle bursts, floating damage text (`-12`, `-25`), screen shake on heavy hooks, and red hit flashes!
- **16-Bit SNES Background Music (BGM)**:
  - Retro SNES soundtrack synthesized via Web Audio API with lead synth melody, walking 16-bit bassline, and rhythm percussion.
  - Dedicated `🎵 BGM MUSIC: ON / OFF` toggle button.
- **5 Elaborate 16-Bit Fighters & Dictator Boss**:
  1. **Stage 1**: *Spike (Rookie)* - Street Punk with yellow mohawk & studded leather vest (Easy)
  2. **Stage 2**: *Bruno (Brawler)* - Alley Champ with camo pants & headband (Medium)
  3. **Stage 3**: *Duke (Heavyweight)* - Iron Duke with gold chains & boxing gloves (Hard)
  4. **Stage 4**: *Kage (Shadow)* - Shadow Ninja with purple shinobi suit & cowl (Expert)
  5. **Stage 5 (FINAL BOSS)**: *General Ironclad (The Dictator)* - Highly detailed 16-bit Military Dictator with peak military cap, gold eagle emblem, double-breasted officer tunic, golden fringed epaulets, multi-color award ribbons, belt buckle, and dictator moustache!
- **Responsive Controls**: Full support for Keyboard (`A/D/Z/X/Space/Enter`) and Touchscreen controls for mobile devices.

---

## 📁 Repository Directory Structure

```text
.
├── .github/
│   └── workflows/
│       ├── deploy.yml     # Automated CI/CD Deployment Workflow with Concurrency Lock
│       └── destroy.yml    # Remote Destruction & Cleanup Workflow
├── scripts/
│   └── startup.sh         # Nginx + 16-Bit SNES Urban Champion Web App
├── .gitignore
├── main.tf                # Main Terraform GCP Infrastructure Specs with GCS Backend
├── outputs.tf             # Outputs (Public IP, Web URL, VPC, Subnet)
├── variables.tf           # Terraform Input Variables Definition
└── README.md              # Project Documentation
```

---

## 🛠️ Step-by-Step Setup Guide: GCP & GitHub Secrets

### Step 1: Configure GCP CLI Project
Open your terminal with the `gcloud` CLI logged in:

```bash
# 1. Set your GCP Project ID
export GCP_PROJECT_ID="your-gcp-project-id"
gcloud config set project $GCP_PROJECT_ID

# 2. Enable required GCP APIs
gcloud services enable compute.googleapis.com \
                       iam.googleapis.com \
                       cloudresourcemanager.googleapis.com
```

### Step 2: Create a Dedicated Service Account
Create a dedicated Service Account for Terraform automation:

```bash
gcloud iam service-accounts create 8bitcitychamp-sa \
    --description="CI/CD Service Account for 8bitCityChamp Terraform" \
    --display-name="8bitcitychamp-sa"
```

### Step 3: Assign IAM Roles
Grant necessary IAM permissions to manage Compute Engine instances, VPC networks, and service accounts:

```bash
# Compute Admin Role
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member="serviceAccount:8bitcitychamp-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/compute.admin"

# Service Account User Role
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member="serviceAccount:8bitcitychamp-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"
```

### Step 4: Generate Service Account Key JSON
Export the Service Account key to a JSON file locally:

```bash
gcloud iam service-accounts keys create 8bitcitychamp-sa-key.json \
    --iam-account=8bitcitychamp-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com
```

### Step 5: Configure GitHub Repository Secrets
In your GitHub repository:
1. Navigate to **Settings** -> **Secrets and variables** -> **Actions**.
2. Click **New repository secret** and add:

| Secret Name | Description / Value |
| :--- | :--- |
| `GCP_PROJECT_ID` | Your GCP Project ID (e.g. `my-gcp-project-12345`) |
| `GCP_SA_KEY` | The **entire raw JSON** contents of `8bitcitychamp-sa-key.json` |

---

## 🚀 GitHub Actions CI/CD Workflows

### 1. Deployment Workflow (`deploy.yml`)
- **Triggers**: `push` to `main`, `Feature1Infraestructure`, `Feature2Game` branches, or manually via `workflow_dispatch`.
- **Concurrency Lock**: Serializes deployments to prevent state lock collisions.
- **Pipeline**: Runs `terraform init`, `terraform plan`, and `terraform apply -auto-approve`.
- **Result**: Provisions the GCP VM, static public IP, network rules, and serves the 16-bit arcade web game at `http://<PUBLIC_IP>`.

### 2. Destruction & Cleanup Workflow (`destroy.yml`)
- **Trigger**: Manual (`workflow_dispatch`).
- **Pipeline**: Runs `terraform destroy -auto-approve`.
- **Result**: Safely destroys 100% of provisioned GCP infrastructure to eliminate ongoing cloud costs.

---

## 📄 License & Credits
Built for **8bitCityChamp**. Powered by **Google Cloud Platform**, **Terraform**, and **GitHub Actions**.
