<!-- # Ansible Deploy для love_bot

Проект автоматизирует подготовку сервера и деплой Telegram-бота `love_bot` из Docker Hub. Playbook создает пользователя, настраивает Git/GitHub, готовит Docker-окружение и запускает контейнер с образом `azatone/love_bot:latest`.

## Что внутри

```text
ansible.cfg                 # настройки Ansible, включая vault_password_file
inventory.ini               # группы и хосты для деплоя
playbook_roles.yml          # основной playbook
group_vars/all/main.yml     # общие переменные без секретов
group_vars/all/vault.yml    # секреты, зашифрованные Ansible Vault
roles/user/                 # пользователь, Git, SSH-ключ, GitHub repo
roles/deploy_bot/           # Docker, compose-файл, .env и запуск бота
_archive/                   # локальный архив старых экспериментов, не пушится в git
```

## Роли

### `user`

Роль готовит пользователя для работы с проектом:

- устанавливает Git;
- создает пользователей из переменной `users`;
- задает shell `/bin/bash`;
- добавляет отображение git-ветки в prompt;
- настраивает `user.name` и `user.email`;
- создает SSH-ключ;
- добавляет публичный ключ в GitHub;
- создает репозиторий GitHub;
- инициализирует локальный проект и пушит первый коммит.

### `deploy_bot`

Роль деплоит бота:

- устанавливает Docker и docker-compose;
- добавляет пользователя в группу `docker`;
- генерирует `docker-compose.yml`;
- генерирует `.env` из vault-переменных;
- скачивает свежий образ `azatone/love_bot:latest`;
- запускает контейнер `love_bot`.

## Переменные

Основные несекретные переменные лежат в `group_vars/all/main.yml`:

```yaml
github_username: "Azat"
dockerhub_username: azatone

users:
  - name: devops
    email: azatone@gmail.com
    project_name: love_bot
```

Секреты хранятся в `group_vars/all/vault.yml` и не должны попадать в открытый вид. В проекте ожидаются переменные:

```yaml
github_token: ...
telegram_bot_token: ...
deepseek_api_key: ...
```

Пароль от vault указан через `ansible.cfg`:

```ini
[defaults]
vault_password_file = vault.txt
```

Файлы `vault.txt` и `group_vars/all/vault.yml` добавлены в `.gitignore`.

## Запуск

Проверить доступность хостов:

```bash
make ping
```

Проверить синтаксис playbook:

```bash
ansible-playbook --syntax-check playbook_roles.yml -i inventory.ini
```

Посмотреть доступные теги:

```bash
ansible-playbook playbook_roles.yml -i inventory.ini --list-tags
```

Запустить полный playbook:

```bash
ansible-playbook playbook_roles.yml -i inventory.ini
```

Запустить через Makefile:

```bash
make playbook
```

Dry-run:

```bash
make playbook_check
```

## Полезные теги

Запустить только подготовку пользователя:

```bash
ansible-playbook playbook_roles.yml -i inventory.ini -t user
```

Запустить только деплой бота:

```bash
ansible-playbook playbook_roles.yml -i inventory.ini -t deploy_bot
```

Подготовить Docker на сервере:

```bash
ansible-playbook playbook_roles.yml -i inventory.ini -t docker
```

Обновить конфиги контейнера:

```bash
ansible-playbook playbook_roles.yml -i inventory.ini -t config
```

Скачать свежий Docker-образ:

```bash
ansible-playbook playbook_roles.yml -i inventory.ini -t image
```

Перезапустить compose:

```bash
ansible-playbook playbook_roles.yml -i inventory.ini -t compose
```

## Деплой нового образа

После публикации нового Docker-образа в Docker Hub достаточно запустить:

```bash
ansible-playbook playbook_roles.yml -i inventory.ini -t deploy_bot
```

Роль выполнит `docker pull` и `docker-compose up -d` на сервере.

## Проверка на сервере

Проверить контейнер:

```bash
docker ps
docker logs -f love_bot
```

Проверить доступность Telegram API с сервера:

```bash
curl -4 --connect-timeout 10 https://api.telegram.org
```

Если Telegram API недоступен по сети, контейнер может быть запущен, но бот не будет отвечать. В таком случае нужен другой VPS, прокси или VPN-маршрут до Telegram. -->

# Ansible Deploy для love_bot

Проект автоматизирует подготовку сервера и деплой Telegram-бота **love_bot** с использованием Ansible и Docker.

Playbook выполняет полный цикл настройки инфраструктуры:

* создание пользователя
* настройка Git и SSH
* интеграция с GitHub
* установка Docker
* деплой контейнера из Docker Hub

---

## 🚀 Основные возможности

* Полностью автоматизированный деплой одной командой
* Идемпотентные Ansible playbook’и
* Безопасное хранение секретов через Ansible Vault
* Интеграция с GitHub API (SSH-ключи, репозитории)
* Контейнеризация приложения через Docker
* Деплой через docker-compose

---

## 📁 Структура проекта

```
ansible.cfg
inventory.ini
playbook_roles.yml

group_vars/
└── all/
    ├── main.yml
    └── vault.yml

roles/
├── user/
└── deploy_bot/
```

---

## ⚙️ Роли

### user

Подготавливает пользователя и Git-окружение:

* установка Git
* создание пользователей
* настройка shell (/bin/bash)
* настройка git config
* генерация SSH-ключей
* добавление ключей в GitHub через API
* создание GitHub репозитория
* клонирование проекта

---

### deploy_bot

Деплой приложения:

* установка Docker и docker-compose
* добавление пользователя в docker group
* генерация docker-compose.yml
* генерация .env из vault
* загрузка Docker-образа
* запуск контейнера

---

## 🔐 Переменные

### Основные (group_vars/all/main.yml)

```yaml
github_username: "Azat"
dockerhub_username: azatone

users:
  - name: devops
    email: azatone@gmail.com
    project_name: love_bot
```

---

### Секреты (Ansible Vault)

```
group_vars/all/vault.yml
```

Содержит:

* github_token
* telegram_bot_token
* deepseek_api_key

---

## ▶️ Запуск

```bash
ansible-playbook playbook_roles.yml -i inventory.ini
```

---

## 🏷️ Теги

| Тег        | Назначение            |
| ---------- | --------------------- |
| user       | подготовка сервера    |
| deploy_bot | деплой приложения     |
| docker     | установка Docker      |
| config     | обновление .env       |
| image      | pull образа           |
| compose    | перезапуск контейнера |

---

## 🔄 Деплой обновлений

После публикации нового Docker-образа:

```bash
ansible-playbook playbook_roles.yml -i inventory.ini -t deploy_bot
```

---

## 🔍 Проверка

```bash
docker ps
docker logs -f love_bot
```

---

## 🌐 Сетевые ограничения

Если Telegram API недоступен:

```bash
curl https://api.telegram.org
```

→ требуется VPS с доступом к Telegram или использование VPN/Proxy

---

## 👨‍💻 Автор

Azat (GitHub: azatone-art)
