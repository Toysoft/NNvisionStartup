#Set up de l'UX/UI


###################///////////////////FICHIERS D'OUVERTURE DE LA PAGE RESIDENT////////////////////////###############################
touch /home/$1/Documents/runUserInterface.py

echo "#!/usr/bin/env python3
import os
import json
import webbrowser
import subprocess
with open('/home/nnvision/conf/conf.json') as n:
    keyLoader = json.load(n)

firefox = '/usr/bin/firefox %s'
key = keyLoader["'"'"key"'"'"]
address = f'https://dev.jouvencia.net/app4/auth/{key}/'
os.system('export DISPLAY=:1')
subprocess.run(['/usr/bin/chromium-browser', '--no-sandbox','--lang-fr', '--disable-features=Translate', '--kiosk', address])


" > /home/$1/Documents/runUserInterface.py
chmod +x /home/$1/Documents/runUserInterface.py

touch /home/$1/Documents/runUserInterface.desktop

echo "[Desktop Entry]
Name=LXTerminal
Type=Application
Exec=/home/$1/Documents/runUserInterface.py
" > /home/$1/Documents/runUserInterface.desktop

cp /home/$1/Documents/runUserInterface.desktop /etc/xdg/autostart/runUserInterface.desktop
touch ~/.config/autostart
echo "[Desktop Entry]
Name=LXTerminal
Type=Application
Exec=/home/$1/Documents/runUserInterface.py
" > ~/.config/autostart

#####################################////////////////////////////////////////////////////////////##############################



apt install crudini
apt autoremove
apt update
apt upgrade
apt autoremove
chmod -x $(type -p gnome-keyring-daemon)
crudini --set /etc/gdm3/custom.conf daemon AutomaticLoginEnable true
crudini --set /etc/gdm3/custom.conf daemon AutomaticLogin $1
sed -i -r "s/(\S*)\s*=\s*(.*)/\1=\2/g" /etc/gdm3/custom.conf

gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

mv /usr/bin/gnome-keyring-daemon /usr/bin/gnome-keyring-daemon.bak

#Set up des permissions docker pour lancer initService.py
groupadd docker
usermod -aG docker $1
newgrp docker 
