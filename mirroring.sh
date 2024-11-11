#!/bin/bash

# Установка необходимых пакетов
sudo apt-get update
sudo apt-get install -y wget rclone

# Создание начальной конфигурации rclone
rclone config create onedrive onedrive

# Проверка конфигурации rclone
if ! rclone config show onedrive; then
    echo "Не удалось создать конфигурацию rclone для onedrive."
    exit 1
fi

# Ждем завершения настройки rclone
while ! rclone config show onedrive; do
    sleep 5
done

echo "Конфигурация rclone завершена."

# Запрашиваем URL для скачивания у пользователя
read -p "Введите URL для скачивания: " DOWNLOAD_URL

# Создаём папку Downloads, если она не существует
DOWNLOAD_DIR="Downloads"
if [ ! -d "$DOWNLOAD_DIR" ]; then
    mkdir "$DOWNLOAD_DIR"
fi

# Скачиваем файл в папку Downloads
wget -P "$DOWNLOAD_DIR" "$DOWNLOAD_URL"

# Загрузка всех файлов из папки Downloads в OneDrive
rclone copy "$DOWNLOAD_DIR" onedrive:/GSI --include "*"

echo "Все файлы из папки Downloads успешно загружены в папку GSI на OneDrive."
