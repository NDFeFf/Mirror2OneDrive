#!/bin/bash

# Установка необходимых пакетов
sudo apt-get update
sudo apt-get install -y wget rclone

# Создание конфигурационного файла rclone
cat <<EOF > rclone.conf
[onedrive]
type = onedrive
token = {"access_token":"", "token_type":"Bearer","refresh_token":"", "expiry":""}
drive_id = ""
drive_type = personal
EOF

# Инструкция для пользователя
echo "rclone установлен и частично настроен. Вам необходимо завершить настройку вручную."
echo "Введите команду 'rclone config' и следуйте инструкциям."
echo "Используйте следующую информацию для настройки:"
echo " - Тип хранилища: onedrive"
echo " - ID клиента и секрет клиента можно оставить пустыми, если у вас нет этих данных."
echo " - Разрешения: read/write"
echo " - Используйте автоконфигурацию для получения токенов доступа."
echo "После завершения настройки скрипт продолжит работу автоматически."

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