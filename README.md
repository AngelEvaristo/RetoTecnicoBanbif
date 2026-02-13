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

## Recursos Aprovisionados Necesarios

Antes de ejecutar el flujo de trabajo, asegúrate de que los siguientes recursos estén aprovisionados en AWS:

### 1. **Repositorio de ECR**
- **Nombre**: `retotecnicobanbif`
- **Región**: `us-east-2`
- **Descripción**: Este repositorio almacenará las imágenes Docker de la aplicación.

### 2. **Bucket de S3 para el estado de Terraform**
- **Nombre**: `terraform-state-rto`
- **Ruta del estado**: `ecs/demo-ecs-dev/terraform.tfstate`
- **Descripción**: Este bucket almacenará el archivo de estado remoto de Terraform.

### 3. **Roles de IAM**
- **Descripción**: Asegúrate de que existan roles de IAM con los permisos necesarios para ECS, ECR y S3.

---

## Validación Previa de Docker

- Construye la imagen Docker localmente:
  ```bash
  docker build -t mi-app:1.0 .
  ```

---

## Validación del Despliegue en ECS

Una vez que el flujo de trabajo haya completado el despliegue, sigue estos pasos para validar que la aplicación esté funcionando correctamente en ECS:

### 1. **Verificar el estado de las tareas en ECS**
- Accede a la consola de AWS ECS.
- Navega al cluster `demo-ecs-cluster`.
- Asegúrate de que las tareas estén en estado `RUNNING`.

### 2. **Obtener la URL del balanceador de carga**
- Accede a la consola de AWS EC2.
- Navega a la sección de balanceadores de carga.
- Busca el balanceador asociado al servicio de ECS y copia su DNS público.

### 3. **Probar la aplicación**
- Abre un navegador o usa `curl` para acceder a la URL del balanceador de carga:
  ```bash
  curl http://<IP_PUBLICA>:8081/weatherForecast
  ```
- Deberías recibir una respuesta válida de la aplicación.

### 4. **Revisar logs de la tarea**
- En la consola de AWS ECS, selecciona la tarea en ejecución.
- Haz clic en la pestaña `Logs` para revisar los registros de la aplicación y verificar que no haya errores.
