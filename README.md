# 🎮 8bitCityChamp - Infrastructure as Code (IaC) & CI/CD Pipeline

Proyecto de Infraestructura como Código (IaC) utilizando **Terraform** y **GitHub Actions** para desplegar una página web retro con el clásico juego de 8 bits **Urban Champion (Nintendo NES)** en **Google Cloud Platform (GCP)** sobre una instancia Compute Engine (`e2-micro`).

---

## 📌 Arquitectura y Recursos Creados

Todos los recursos se gestionan con Terraform y llevan el identificador/prefijo `8bitcitychamp`:

- **VM Compute Engine**: `v8bitcitychamp-vm` (`e2-micro`, SO Debian 12)
- **VPC Dedicada**: `v8bitcitychamp-vpc`
- **Subred**: `v8bitcitychamp-subnet` (`10.0.1.0/24`)
- **Reglas de Firewall**:
  - `v8bitcitychamp-firewall-http` (Puerto 80 HTTP)
  - `v8bitcitychamp-firewall-ssh` (Puerto 22 SSH)
- **IP Pública Estática**: `v8bitcitychamp-ip`
- **Provisionamiento (Sin Ansible)**: `scripts/startup.sh` inyectado mediante `metadata_startup_script` instala Nginx y despliega la aplicación web retro interactiva.

---

## 📁 Estructura del Proyecto

```text
.
├── .github/
│   └── workflows/
│       ├── deploy.yml     # Workflow CI/CD de Despliegue Automático y Manual
│       └── destroy.yml    # Workflow CI/CD de Destrucción Remota Total
├── scripts/
│   └── startup.sh         # Script de inicio (Nginx + Urban Champion 8-Bit Web App)
├── .gitignore
├── main.tf                # Configuración principal de Terraform (GCP)
├── outputs.tf             # Outputs (IP Pública, URL HTTP, VPC, Subnet)
├── variables.tf           # Definición de variables del proyecto
└── README.md
```

---

## 🛠️ Guía Paso a Paso: Configuración de GCP y GitHub Secrets

### Paso 1: Configurar el Proyecto en GCP CLI
Abre tu terminal con `gcloud` CLI e inicia sesión:

```bash
# 1. Definir el ID de tu proyecto en GCP
export GCP_PROJECT_ID="tu-project-id-aqui"
gcloud config set project $GCP_PROJECT_ID

# 2. Habilitar las APIs necesarias en GCP
gcloud services enable compute.googleapis.com \
                       iam.googleapis.com \
                       cloudresourcemanager.googleapis.com
```

### Paso 2: Crear la Cuenta de Servicio (Service Account)
Crearemos una Service Account dedicada para Terraform:

```bash
# Crear la Service Account
gcloud iam service-accounts create 8bitcitychamp-sa \
    --description="Cuenta de servicio CI/CD para 8bitCityChamp Terraform" \
    --display-name="8bitcitychamp-sa"
```

### Paso 3: Asignar Roles de IAM
Otorgamos los permisos necesarios para gestionar Compute, Redes y Service Accounts:

```bash
# Permiso Compute Admin
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member="serviceAccount:8bitcitychamp-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/compute.admin"

# Permiso Service Account User
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member="serviceAccount:8bitcitychamp-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"
```

### Paso 4: Generar y Exportar la Llave JSON
Exportamos la llave de la Service Account a un archivo JSON local:

```bash
gcloud iam service-accounts keys create 8bitcitychamp-sa-key.json \
    --iam-account=8bitcitychamp-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com
```

### Paso 5: Configurar GitHub Secrets
En tu repositorio de GitHub:
1. Ve a **Settings** -> **Secrets and variables** -> **Actions**.
2. Haz clic en **New repository secret** y agrega:

| Nombre del Secret | Descripción / Valor |
| :--- | :--- |
| `GCP_PROJECT_ID` | El ID de tu proyecto en GCP (ej. `mi-proyecto-123456`) |
| `GCP_SA_KEY` | El contenido **completo** del archivo JSON `8bitcitychamp-sa-key.json` |

> ⚠️ **Seguridad**: Elimina el archivo `8bitcitychamp-sa-key.json` de tu máquina local tras guardarlo en GitHub:
> ```bash
> rm 8bitcitychamp-sa-key.json
> ```

---

## 🚀 Flujo de CI/CD en GitHub Actions

### 1. Despliegue Automático/Manual (`deploy.yml`)
- **Disparadores**: `push` a la rama `main` / `Feature1Infraestructure` o ejecución manual vía `workflow_dispatch`.
- **Acciones**: Ejecuta `terraform init`, `terraform plan` y `terraform apply -auto-approve`.
- **Resultado**: Despliega la VM `e2-micro`, asigna la IP estática y levanta la web en `http://<IP_PUBLICA>`.

### 2. Destrucción Remota Total (`destroy.yml`)
- **Disparadores**: Manual (`workflow_dispatch`).
- **Acciones**: Ejecuta `terraform destroy -auto-approve`.
- **Resultado**: Elimina el 100% de la infraestructura (VM, IP, subred, VPC y reglas de firewall) para garantizar **Costo Mínimo** y cero residuos.

---

## 🕹️ Probar Localmente con Terraform (Opcional)

Si deseas probar la infraestructura localmente antes de usar GitHub Actions:

```bash
# Inicializar Terraform
terraform init

# Validar sintaxis
terraform validate

# Planificar despliegue
terraform plan -var="project_id=TU_PROJECT_ID"

# Aplicar despliegue
terraform apply -var="project_id=TU_PROJECT_ID" -auto-approve

# Eliminar infraestructura localmente
terraform destroy -var="project_id=TU_PROJECT_ID" -auto-approve
```
