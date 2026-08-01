# 🎮 8bitCityChamp - Infrastructure as Code (IaC) & CI/CD Pipeline

An Infrastructure as Code (IaC) project built with **Terraform** and **GitHub Actions** to automatically deploy a vintage retro 8-bit web arcade game (**Urban Champion NES Edition**) on **Google Cloud Platform (GCP)** using a Compute Engine instance (`e2-micro`).

---

## 📌 Architecture & Provisioned Resources

All GCP infrastructure resources are managed via Terraform using the `8bitcitychamp` prefix:

- **Compute Engine VM**: `v8bitcitychamp-vm` (`e2-micro`, Debian 12 OS)
- **Dedicated VPC**: `v8bitcitychamp-vpc`
- **Subnet**: `v8bitcitychamp-subnet` (`10.0.1.0/24`)
- **Firewall Rules**:
  - `v8bitcitychamp-firewall-http` (Port 80 HTTP)
  - `v8bitcitychamp-firewall-ssh` (Port 22 SSH)
- **Static Public External IP**: `v8bitcitychamp-ip`
- **Automated Web Provisioning**: `scripts/startup.sh` injected via `metadata_startup_script` installs Nginx and deploys the interactive 8-bit vintage web arcade game.

---

## 🕹️ Feature2 Arcade Game Enhancements

- **Vintage NES Title Screen**: Retro 8-bit start screen featuring project branding ("8bitCityChamp"), flickering CRT cityscape, pixel graphics, audio chimes, and blinking "PRESS START TO PLAY".
- **English Localization**: Full game UI, controls panel, stage announcements, victory banners, and documentation in English.
- **5 Ascending Difficulty Opponents**:
  1. **Stage 1**: *Spike (Rookie)* - Street Punk (Easy)
  2. **Stage 2**: *Bruno (Brawler)* - Alley Champ (Medium)
  3. **Stage 3**: *Duke (Heavyweight)* - Iron Duke (Hard)
  4. **Stage 4**: *Kage (Shadow)* - Shadow Ninja (Expert)
  5. **Stage 5 (FINAL BOSS)**: *General Ironclad (The Dictator)* - A vintage military dictator outfitted in a green military uniform, officer peak cap with gold star, epaulets, medals, and moustache!
- **Web Audio API Synthesizer**: 8-bit sound effects for punches, hits, blocks, police sirens, stage clears, game over, and victory fanfares.
- **Responsive Controls**: Full support for Keyboard (`A/D/Z/X/Space/Enter`) and Touchscreen controls for mobile devices.

---

## 📁 Repository Directory Structure

```text
.
├── .github/
│   └── workflows/
│       ├── deploy.yml     # Automated CI/CD Deployment Workflow
│       └── destroy.yml    # Remote Destruction & Cleanup Workflow
├── scripts/
│   └── startup.sh         # Nginx + Vintage Urban Champion 8-Bit Web App
├── .gitignore
├── main.tf                # Main Terraform GCP Infrastructure Specs
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

> ⚠️ **Security Notice**: Safely remove `8bitcitychamp-sa-key.json` from your local machine after configuring GitHub Secrets:
> ```bash
> rm 8bitcitychamp-sa-key.json
> ```

---

## 🚀 GitHub Actions CI/CD Workflows

### 1. Deployment Workflow (`deploy.yml`)
- **Triggers**: `push` to `main`, `Feature1Infraestructure`, `Feature2Game` branches, or manually via `workflow_dispatch`.
- **Pipeline**: Runs `terraform init`, `terraform plan`, and `terraform apply -auto-approve`.
- **Result**: Provisions the GCP VM, static public IP, network rules, and serves the arcade web game at `http://<PUBLIC_IP>`.

### 2. Destruction & Cleanup Workflow (`destroy.yml`)
- **Trigger**: Manual (`workflow_dispatch`).
- **Pipeline**: Runs `terraform destroy -auto-approve`.
- **Result**: Safely destroys 100% of provisioned GCP infrastructure to eliminate ongoing cloud costs.

---

## 🕹️ Local Testing with Terraform (Optional)

To test infrastructure deployment locally prior to GitHub Actions:

```bash
# Initialize Terraform
terraform init

# Validate syntax
terraform validate

# Create deployment execution plan
terraform plan -var="project_id=YOUR_GCP_PROJECT_ID"

# Apply deployment
terraform apply -var="project_id=YOUR_GCP_PROJECT_ID" -auto-approve

# Destroy infrastructure locally
terraform destroy -var="project_id=YOUR_GCP_PROJECT_ID" -auto-approve
```

---

## 📄 License & Credits
Built for **8bitCityChamp**. Powered by **Google Cloud Platform**, **Terraform**, and **GitHub Actions**.
