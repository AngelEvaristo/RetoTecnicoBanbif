# GitHub Actions Workflow: Build and Push Image to AWS ECR

Este archivo define un flujo de trabajo automatizado para construir, validar y desplegar una aplicación en AWS ECR utilizando Docker y Terraform.

## Descripción del Flujo de Trabajo

### Eventos de Activación
- **Push a la rama `main`**: El flujo de trabajo se activa automáticamente cuando se realiza un push a la rama `main`.

### Jobs

#### 1. **Extract Version**
- **Descripción**: Extrae la versión de la aplicación desde el archivo `CHANGELOG.md`.
- **Pasos**:
  - Clona el repositorio.
  - Busca la versión en el archivo `CHANGELOG.md` y la almacena como una salida del job.

#### 2. **Build and Push to ECR**
- **Descripción**: Construye la imagen Docker, realiza validaciones previas y la sube a Amazon ECR.
- **Pasos**:
  - Imprime la versión extraída.
  - Configura las credenciales de AWS.
  - Inicia sesión en Amazon ECR.
  - Realiza una validación previa construyendo y ejecutando la imagen Docker localmente.
  - Construye, etiqueta y sube la imagen a Amazon ECR.

#### 3. **Terraform Setup and Deployment**
- **Descripción**: Configura Terraform y aplica los cambios de infraestructura.
- **Pasos**:
  - Configura Terraform con la versión `1.6.6`.
  - Inicializa Terraform con el backend remoto definido en `backend-dev.hcl`.
  - Valida los archivos de configuración de Terraform.
  - Genera un plan de ejecución (`tfplan`).
  - Aplica los cambios definidos en el plan.

---

## Configuración de AWS

### Credenciales
- **AWS_ACCESS_KEY_ID**: Se configura como un secreto en el repositorio.
- **AWS_SECRET_ACCESS_KEY**: Se configura como un secreto en el repositorio.
- **Región**: `us-east-2`.

### Repositorio de ECR
- **Nombre del repositorio**: `retotecnicobanbif`.

---

## Validación Previa de Docker

- Construye la imagen Docker localmente:
  ```bash
  docker build -t mi-app:1.0 .
