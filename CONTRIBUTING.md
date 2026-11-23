# Contributing to MediCAB

Thank you for contributing to the **MediCAB** project! To maintain code quality, stability, and smooth collaboration across our 9-member team, please follow these guidelines.

---

## 1. Branching Strategy (Git Flow)

- **`main`**: Production-ready branch. **Direct pushes are strictly prohibited.**
- **`develop`**: Integration branch for ongoing development.
- **Feature Branches**: Branch out from `develop` for every task or feature.

### Branch Naming Convention
- `feature/<module>-<short-description>` (e.g. `feature/auth-jwt-integration`, `feature/patient-management`)
- `bugfix/<issue-name>` (e.g. `bugfix/login-cors-error`)
- `devops/<topic>` (e.g. `devops/docker-optimization`)

---

## 2. Development Workflow

1. **Pull the latest changes:**
   ```bash
   git checkout develop
   git pull origin develop
   ```

2. **Create a new branch:**
   ```bash
   git checkout -b feature/my-new-feature
   ```

3. **Develop and test locally:**
   - Verify that your code runs without console errors.
   - Run the backend and frontend tests before committing.

4. **Commit using Conventional Commits:**
   ```bash
   git commit -m "feat(auth): add login endpoint with token validation"
   git commit -m "fix(clinic): resolve appointment scheduling timezone bug"
   ```

5. **Push and create a Pull Request (PR):**
   ```bash
   git push -u origin feature/my-new-feature
   ```
   - Open a PR targeting `develop` (or `main`).
   - Fill in the PR template.
   - Request review from at least 1 team member.
   - Wait for GitHub Actions CI checks to pass before merging.

---

## 3. DevOps & Security Rules

- ⛔ **NEVER commit `.env` or sensitive credentials** (passwords, secret keys, tokens).
- ⛔ **NEVER commit `node_modules/`, `.venv/`, or compiled `.pyc` files.**
- ✅ Always update `.env.example` if you introduce a new environment variable.
