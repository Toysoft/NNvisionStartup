#Set up de l'UX/UI
apt install crudini
crudini --set /etc/gdm3/custom.conf daemon AutomaticLoginEnable true
crudini --set /etc/gdm3/custom.conf daemon AutomaticLogin $1
gsettings set org.gnome.desktop.screensaver lock-enabled false
chmod -x $(type -p gnome-keyring-daemon)



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
subprocess.run(['/usr/bin/chromium-browser', '--no-sandbox', '--kiosk', address])


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