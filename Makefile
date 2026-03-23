# Makefile
tag ?=
skip ?=
ping: # Проверяет доступность сервера по ip-адресу
	ansible all -i inventory.ini -u devops -m ping

# проверка
playbook_check: # Запускает playbook.yml с тегом для проверки
	ansible-playbook --check playbook.yml -i inventory.ini \
	$(if $(tag),-t $(tag)) \
	$(if $(skip),--skip-tags $(skip))

playbook_remove_check: # Запускает playbook_remove_check.yml с тегом
	ansible-playbook --check playbook_remove.yml -i inventory.ini \
	$(if $(tag),-t $(tag)) \
	$(if $(skip),--skip-tags $(skip))

# выполнение
playbook: # Запускает playbook.yml с тегом
	ansible-playbook playbook.yml -i inventory.ini \
	$(if $(tag),-t $(tag)) \
	$(if $(skip),--skip-tags $(skip))

playbook_remove: # Запускает playbook_remove.yml с тегом
	ansible-playbook playbook_remove.yml -i inventory.ini \
	$(if $(tag),-t $(tag)) \
	$(if $(skip),--skip-tags $(skip))