# SkillShare Network 🔄

**SkillShare Network** — это интеллектуальная платформа для безденежного обмена навыками и услугами. Система использует умные алгоритмы для выстраивания цепочек обмена между специалистами, позволяя обмениваться знаниями без использования валюты.

---

## 🛠 Технологический стек

*   **Backend:** Python 3.12, FastAPI, SQLAlchemy 2.0, Pydantic v2.
*   **Frontend:** React, TypeScript, Vite, TailwindCSS.
*   **Database:** PostgreSQL 15 (основное хранилище).
*   **Caching/Queue:** Redis 7.
*   **Infrastructure:** Docker, Docker Compose.
*   **Linting:** Ruff (Python), ESLint/Prettier (JS).

---

## 🚀 Быстрый старт (Docker)

Самый простой способ запустить проект — использовать Docker Compose.

1.  **Подготовка окружения:**
    Скопируйте пример файла настроек и заполните его:
    ```bash
    cp backend/.env.example backend/.env
    ```
    *Отредактируйте `backend/.env`, указав свои секретные ключи.*

2.  **Запуск системы:**
    ```bash
    docker compose --profile full up -d --build
    ```

3.  **Доступ к приложению:**
    *   **Frontend:** [http://localhost:5173](http://localhost:5173)
    *   **Backend API:** [http://localhost:8000](http://localhost:8000)
    *   **API Docs (Swagger):** [http://localhost:8000/docs](http://localhost:8000/docs)

---

## ⚙️ Переменные окружения (.env)

Проект требует наличия следующих переменных в файле `backend/.env`:

| Переменная | Описание | Пример |
| :--- | :--- | :--- |
| `SSN_SECRET_KEY` | Ключ для подписи JWT-токенов | `your-super-secret-key` |
| `SSN_DATABASE_URL` | URL подключения к PostgreSQL | `postgresql+asyncpg://user:pass@db:5432/db` |
| `SSN_REDIS_URL` | URL подключения к Redis | `redis://redis:6379/0` |

---

## 📂 Структура проекта

*   `backend/` — Исходный код сервера (FastAPI).
    *   `app/core/settings.py` — Конфигурация приложения.
*   `frontend/` — Исходный код клиента (React).
*   `docker-compose.yml` — Описание сервисов и их связей.
*   `Documentation/` — Техническая документация и схемы.

---

## 👨‍🔧 Сопровождение (Maintenance)

Для проверки качества кода (линтер Ruff):
```bash
cd backend
ruff check .
```

Устранение проблем с портами (если порт 8000 занят):
```bash
sudo lsof -i :8000
docker stop <PID/ContainerID>
```
