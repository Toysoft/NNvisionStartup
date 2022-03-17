#Set up de l'UX/UI


###################///////////////////FICHIERS D'OUVERTURE DE LA PAGE RESIDENT////////////////////////###############################
rm /home/$1/runUserInterface.py
touch /home/$1/runUserInterface.py
touch /home/$1/chromiumKiller.py
echo "#!/usr/bin/env python3
import sys
import os
import json
import signal
import subprocess
try:
    import pgrep
except ImportError:
    import pip
    pip.main(['install', 'pgrep'])
with open ("'"'"/home/nnvision/kill.json"'"'","'"'"r"'"'") as f:
    killer = json.load(f)
if killer["'"'"kill"'"'"] == True:
    pids = pgrep.pgrep("'"'"chromium-browse"'"'")
    for p in pids:
        os.kill(p,15)
    with open ("'"'"/home/nnvision/kill.json"'"'", "'"'"w"'"'") as f:
        killer = {"'"'"kill"'"'":False}
        json.dump(killer, f)
">/home/$1/chromiumKiller.py
touch /home/$1/kill.json
chmod 777 /home/$1/kill.json
touch /etc/cron.d/chromiumKiller
echo "
* * * * * root cd /home/nnvision && python3 /home/nnvision/chromiumKiller.py > /home/nnvision/log_killer.txt 2>&1
#
">/etc/cron.d/chromiumKiller
echo "{"'"'"kill"'"'": false}">/home/$1/kill.json
echo "#!/usr/bin/env python3
import os
import json
import webbrowser
import subprocess
import sys
import pgrep
import signal
import time
with open('/home/nnvision/conf/conf.json') as n:
    keyLoader = json.load(n)
sys.path.append("'"'"/home/nnvision/conf"'"'")
from settingslocal import *
firefox = '/usr/bin/firefox %s'
key = keyLoader["'"'"key"'"'"]
address = f'{SERVER}app4/auth/{key}/'
os.system('export DISPLAY=:1')
print('etape1')
with open ("'"'"/home/nnvision/kill.json"'"'", "'"'"w"'"'") as f:
    killer = {"'"'"kill"'"'":True}
    json.dump(killer, f)
subprocess.run(['/usr/bin/chromium-browser','--no-recovery-component','--no-crash-upload','--no-report-upload','--no-first-run','--no-initial-navigation','-disable-device-discovery-notifications','--no-default-browser-check','--use-fake-ui-for-media-stream' ,'--no-sandbox','--lang=locale','--user-data-dir="'"'"~/.config/chromium"'"'"', '--disable-features=Translate', '--start-fullscreen', f'--app={address}'])
print('appli prevent fermée')
subprocess.run(['/usr/bin/chromium-browser','--no-recovery-component','--no-crash-upload','--no-report-upload','--no-first-run','--no-initial-navigation','-disable-device-discovery-notifications','--no-default-browser-check','--use-fake-ui-for-media-stream' ,'--no-sandbox','--lang=locale','--user-data-dir="'"'"~/.config/chromium"'"'"', '--disable-features=Translate', '--start-fullscreen', f'--app={address}'])
print('appli lancée')
" > /home/$1/runUserInterface.py
chmod +x /home/$1/runUserInterface.py

rm /home/$1/runUserInterface.desktop
touch /home/$1/runUserInterface.desktop

echo "[Desktop Entry]
Name=LXTerminal
Type=Application
Exec=lxterminal -e /home/$1/runUserInterface.py
" > /home/$1/runUserInterface.desktop

rm /etc/xdg/autostart/runUserInterface.desktop
cp /home/$1/runUserInterface.desktop /etc/xdg/autostart/runUserInterface.desktop
touch ~/.config/autostart
echo "[Desktop Entry]
Name=LXTerminal
Type=Application
Exec=lxterminal -e /home/$1/runUserInterface.py
" > ~/.config/autostart

#####################################////////////////////////////////////////////////////////////##############################


#Ubuntu Setup
apt install crudini
apt autoremove
apt update
apt autoremove
chmod -x $(type -p gnome-keyring-daemon)
crudini --set /etc/gdm3/custom.conf daemon AutomaticLoginEnable true
crudini --set /etc/gdm3/custom.conf daemon AutomaticLogin $2
sed -i -r "s/(\S*)\s*=\s*(.*)/\1=\2/g" /etc/gdm3/custom.conf

gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
gsettings set org.gnome.settings-daemon.plugins.power active false
gsettings set org.gnome.desktop.lockdown disable-lock-screen true


mv /usr/bin/gnome-keyring-daemon /usr/bin/gnome-keyring-daemon.bak

rm /etc/default/apport
touch /etc/default/apport
echo "# set this to 0 to disable apport, or to 1 to enable it
# you can temporarily override this with
# sudo service apport start force_start=1
enabled=0

" > /etc/default/apport


mkdir /home/nnvision
useradd nnvision

#Set up des permissions docker pour lancer initService.py
groupadd docker
usermod -aG docker $2
newgrp docker 
