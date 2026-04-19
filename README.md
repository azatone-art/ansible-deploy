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

## 🛡️ Защита секретов

Роль `user` обеспечивает базовую защиту секретов в репозитории:

* автоматически создает `.gitignore` в удаленном проекте
* добавляет правила для исключения:

  * `.env`
  * `.env.*`
  * исключение для `.env.example`

Перед выполнением `git add .` роль дополнительно выполняет:

```bash
git rm --cached --ignore-unmatch .env
```

Это предотвращает попадание секретов в Git при повторном запуске ролей.

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
| config     | обновление compose/.env |
| image      | pull образа           |
| compose    | применение docker-compose |

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
