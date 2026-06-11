import logging
import sys
from logging.handlers import RotatingFileHandler
from pathlib import Path

# Путь к папке с логами (внутри контейнера это будет /app/logs)
LOG_DIR = Path("logs")
LOG_DIR.mkdir(exist_ok=True)

def setup_logging():
    # Базовый формат лога: Время - Имя логгера - Уровень - Сообщение
    log_format = logging.Formatter(
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )

    # Очищаем существующие обработчики, если они есть
    logging.getLogger().handlers = []

    # 1. Обработчик для КОНСОЛИ (уровень INFO и выше)
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(log_format)
    console_handler.setLevel(logging.INFO)

    # 2. Обработчик для ФАЙЛА (только ERROR и выше + ротация)
    # Храним до 5 файлов по 5 МБ каждый
    file_handler = RotatingFileHandler(
        LOG_DIR / "errors.log", 
        maxBytes=5*1024*1024, 
        backupCount=5,
        encoding="utf-8"
    )
    file_handler.setFormatter(log_format)
    file_handler.setLevel(logging.ERROR)

    # Настройка корневого логгера
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.INFO)
    root_logger.addHandler(console_handler)
    root_logger.addHandler(file_handler)

    logging.info("Система логирования инициализирована: консоль (INFO), файл (ERROR).")
