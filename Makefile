# Makefile
ping: # Проверяет доступность сервера по ip-адресу
	ansible all -i inventory.ini -u devops -m ping
