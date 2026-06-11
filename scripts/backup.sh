#!/bin/bash

# Скрипт создания резервной копии базы данных PostgreSQL
# Использование: ./scripts/backup.sh

# Настройки
BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/db_backup_$TIMESTAMP.sql"
DB_SERVICE="db"
DB_NAME="skillshare"
DB_USER="postgres"

# Создаем папку для бэкапов, если её нет
mkdir -p $BACKUP_DIR

echo "🚀 Начинаю создание резервной копии базы данных..."

# Выполняем дамп базы внутри контейнера и сохраняем в файл на хосте
# Используем --profile full, так как проект запущен с этим профилем
docker compose --profile full exec -T $DB_SERVICE pg_dump -U $DB_USER $DB_NAME > $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "✅ Бэкап успешно создан: $BACKUP_FILE"
    # Удаляем старые бэкапы (оставляем только последние 7 дней)
    find $BACKUP_DIR -type f -name "*.sql" -mtime +7 -delete
    echo "🧹 Старые копии (старше 7 дней) удалены."
else
    echo "❌ Ошибка при создании бэкапа!"
    exit 1
fi
