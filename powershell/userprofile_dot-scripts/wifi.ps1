# shows wifi and password

param($name)

netsh wlan show profile name=$name key=clear
