# Makefile
tag ?=
skip ?=
ping: # Проверяет доступность сервера по ip-адресу
	ansible all -i inventory.ini -u devops -m ping

# проверка
playbook_check: # Запускает playbook_roles.yml с тегом для проверки
	ansible-playbook --check playbook_roles.yml -i inventory.ini \
	$(if $(tag),-t $(tag)) \
	$(if $(skip),--skip-tags $(skip))


# выполнение
playbook: # Запускает playbook_roles.yml с тегом
	ansible-playbook playbook_roles.yml -i inventory.ini \
	$(if $(tag),-t $(tag)) \
	$(if $(skip),--skip-tags $(skip))

