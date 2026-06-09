# Руководство администратора SkillShare Network 🛠

Данный документ предназначен для инженеров по сопровождению и системных администраторов. В нем описаны процессы развертывания, настройки и технического обслуживания платформы.

## 📋 Системные требования

*   **ОС:** Linux (Ubuntu 22.04 LTS рекомендуется).
*   **Процессор:** 2 ядра и выше.
*   **ОЗУ:** 4 ГБ (минимум 2 ГБ при настроенном Swap).
*   **Диск:** 20 ГБ свободного места.
*   **ПО:** Docker 24+, Docker Compose 2.20+.

## 🌐 Схема сетевых портов

| Сервис | Внутренний порт | Внешний порт (Host) | Назначение |
| :--- | :--- | :--- | :--- |
| **Nginx** | 80 / 443 | 80 / 443 | Входная точка для пользователей |
| **Frontend** | 5173 | 5173 | Интерфейс пользователя (React) |
| **Backend** | 8000 | 8000 | API Сервер (FastAPI) |
| **PostgreSQL**| 5432 | 5432 | База данных |
| **Redis** | 6379 | 6379 | Кэш и очереди |

## 🛡 Конфигурация Nginx (Reverse Proxy)

Рекомендуемый конфиг для `/etc/nginx/sites-available/skillshare`:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    # Frontend
    location / {
        proxy_pass http://localhost:5173;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Backend API
    location /api {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # API Documentation (Swagger)
    location /docs {
        proxy_pass http://localhost:8000/docs;
    }
}
```

## 🚑 Устранение неисправностей (Troubleshooting)

### 1. Проверка статуса сервисов
Если сайт недоступен, первым делом проверьте состояние контейнеров:
```bash
docker compose --profile full ps
```

### 2. Просмотр логов
Если сервис `backend` выдает ошибку:
```bash
docker compose --profile full logs -f backend
```

### 3. Перезапуск системы
Для полной перезагрузки с пересборкой (помогает при обновлении кода):
```bash
docker compose --profile full down
docker compose --profile full up -d --build
```

### 4. Проблема с базой данных
Если в логах ошибка подключения к БД:
*   Проверьте наличие файла `backend/.env`.
*   Убедитесь, что переменная `SSN_DATABASE_URL` содержит корректный пароль.
*   Проверьте, запущен ли контейнер `db`.
