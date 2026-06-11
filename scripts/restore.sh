#!/bin/bash

# Скрипт восстановления базы данных PostgreSQL из файла
# Использование: ./scripts/restore.sh backups/db_backup_XXXX.sql

BACKUP_FILE=$1
DB_SERVICE="db"
DB_NAME="skillshare"
DB_USER="postgres"

if [ -z "$BACKUP_FILE" ]; then
    echo "❌ Ошибка: укажите файл бэкапа."
    echo "Пример: ./scripts/restore.sh backups/db_backup_20231027_120000.sql"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Ошибка: файл $BACKUP_FILE не найден!"
    exit 1
fi

echo "⚠️ ВНИМАНИЕ: Текущие данные в базе '$DB_NAME' будут перезаписаны!"
echo "Начинаю восстановление из файла: $BACKUP_FILE..."

# Передаем содержимое файла в psql внутри контейнера
docker compose --profile full exec -T $DB_SERVICE psql -U $DB_USER -d $DB_NAME < $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "✅ Восстановление завершено успешно!"
else
    echo "❌ Ошибка при восстановлении!"
    exit 1
fi
