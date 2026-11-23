# 🏥 MediCAB — Cabinet Médical Management System

MediCAB is a comprehensive medical practice management application designed for doctors, administrative staff, and clinics.

---

## 🏗️ Architecture

- **Backend**: Django 5.2 + Django REST Framework + MySQL 8.0
- **Frontend**: Angular 19 (TypeScript, Standalone Components, Lucide Icons)
- **DevOps**: Docker, Docker Compose, GitHub Actions CI/CD

```
MediCAB-Frontend-Backend/
├── .github/
│   ├── workflows/ci.yml          # Automated CI pipeline (lint, check, build)
│   └── pull_request_template.md  # PR quality checklist
├── MediCAB/
│   ├── MediCaB-backend/          # Django REST API
│   │   ├── accounts/             # Authentication & user management
│   │   ├── clinic/               # Clinic configuration & models
│   │   ├── config/               # Django settings & URL routing
│   │   ├── Dockerfile            # Container definition for backend
│   │   └── requirements.txt      # Python dependencies
│   └── MediCaB-frontend/         # Angular 19 Frontend
│       ├── src/                  # App components, services, assets
│       ├── Dockerfile            # Multi-stage container build
│       └── nginx.conf            # Nginx reverse proxy configuration
├── docker-compose.yml            # Local multi-container orchestration
├── .gitignore                    # Multi-stack git ignore rules
├── .env.example                  # Environment variables template
├── CONTRIBUTING.md               # Team collaboration & branching guide
└── README.md
```

---

## 🚀 Quickstart with Docker (Recommended)

The easiest way for all team members to run the complete stack without managing local MySQL or Python dependencies:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/beraabd/gestion-cabinet-medical-S.git
   cd gestion-cabinet-medical-S
   ```

2. **Create environment file:**
   ```bash
   cp .env.example .env
   ```

3. **Start the whole stack:**
   ```bash
   docker compose up --build
   ```

- **Frontend**: [http://localhost:4200](http://localhost:4200)
- **Backend API**: [http://localhost:8000/api/](http://localhost:8000/api/)
- **MySQL Database**: `localhost:3306`

---

## 💻 Manual Setup (Without Docker)

### 1. Database (MySQL)
Create the database:
```sql
CREATE DATABASE medicab_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2. Backend (Django)
```bash
cd MediCAB/MediCaB-backend
python -m venv .venv
# On Windows: .venv\Scripts\Activate.ps1
# On Linux/macOS: source .venv/bin/activate

pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

### 3. Frontend (Angular)
```bash
cd MediCAB/MediCaB-frontend
npm install
npm start
```
Navigate to [http://localhost:4200](http://localhost:4200).

---

## 👥 Team Collaboration Guidelines
Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our Git Flow, branch naming conventions, and Pull Request workflow.
